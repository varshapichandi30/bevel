apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ name }}-cacerts-job
  namespace: {{ component_ns }}
spec:
  project: {{ component_ns }} 
  source:
    repoURL: https://github.com/Karthikey22/bevel.git
    path: {{ charts_dir }}/generate_cacerts
    targetRevision: HEAD
    helm:
      releaseName: {{ name }}-cacerts-job
      values: |-
          metadata:
            name: {{ component }}
            component_name: {{ component }}-net
            namespace: {{ component_ns }}    
            images:
            fabrictools: {{ fabrictools_image }}
            alpineutils: {{ alpine_image }}

          vault:
            role: vault-role
            address: {{ vault.url }}
            authpath: {{ network.env.type }}{{ component_ns }}-auth
            secretcryptoprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/{{ component_type }}Organizations/{{ component }}-net/ca
            secretcredentialsprefix: {{ vault.secret_path | default('secretsv2') }}/data/credentials/{{ component }}-net/ca/{{ component }}
            serviceaccountname: vault-auth
            imagesecretname: regcred
            
          ca:
            subject: {{ subject }}

  destination:
    server: "https://kubernetes.default.svc"
    namespace: {{ component_ns }}
  syncPolicy:
    automated:
      # Do not enable pruning yet!
      prune: false # Specifies if resources should be pruned during auto-syncing ( false by default ).
      selfHeal: true
