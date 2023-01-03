apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ component_name }}
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Karthikey22/bevel.git
    path: {{ charts_dir }}/fabric_cli
    targetRevision: HEAD
    helm:
      releaseName:  {{ component_name }}
      values: |-
        metadata:
          namespace: {{ component_ns }}
          images:
            fabrictools: {{ fabrictools_image }}
            alpineutils: {{ alpine_image }}
        storage:
          class: {{ storage_class }}
          size: 256Mi
        vault:
          role: vault-role
          address: {{ vault.url }}
          authpath: {{ network.env.type }}{{ component_ns }}-auth
          adminsecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/users/admin
          orderersecretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ component_ns }}/orderer
          serviceaccountname: vault-auth
          imagesecretname: regcred
          tls: false
        peer:
          name: {{ peer.name }}
          localmspid: {{ org.name | lower}}MSP
          tlsstatus: true
{% if network.env.proxy == 'none' %}
          address: {{ peer.name }}.{{ component_ns }}:7051
{% else %}
          address: {{ peer.peerAddress }}
{% endif %}
        orderer:
          address: {{ orderer.uri }}
  destination:
    server: "https://kubernetes.default.svc"
    namespace: {{ component_ns }}
  syncPolicy:
    automated:
      # Do not enable pruning yet!
      prune: false # Specifies if resources should be pruned during auto-syncing ( false by default ).
      selfHeal: true
  