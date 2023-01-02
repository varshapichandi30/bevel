apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: {{ name }}-{{ peer_name }}
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/Karthikey22/bevel.git
    path: {{ charts_dir }}/peernode
    targetRevision: HEAD
    helm:
      releaseName: {{ name }}-{{ peer_name }}
      values: |-
          metadata:
            namespace: {{ peer_ns }}
            images:
              couchdb: hyperledger/fabric-couchdb:0.4.22 #prev {{ couchdb_image}}
              peer: {{ peer_image }}
              alpineutils: {{ alpine_image }}
      {% if network.env.annotations is defined %}
          annotations:  
            service:
      {% for item in network.env.annotations.service %}
      {% for key, value in item.items() %}
              - {{ key }}: {{ value | quote }}
      {% endfor %}
      {% endfor %}
            pvc:
      {% for item in network.env.annotations.pvc %}
      {% for key, value in item.items() %}
              - {{ key }}: {{ value | quote }}
      {% endfor %}
      {% endfor %}
            deployment:
      {% for item in network.env.annotations.deployment %}
      {% for key, value in item.items() %}
              - {{ key }}: {{ value | quote }}
      {% endfor %}
      {% endfor %}
      {% endif %}        
          peer:
            name: {{ peer_name }}
            gossippeeraddress: {{ peer.gossippeeraddress }}
      {% if provider == 'none' %}
      gossipexternalendpoint: {{ peer_name }}.{{ peer_ns }}:7051
      {% else %}
            gossipexternalendpoint: {{ peer_name }}.{{ peer_ns }}.{{item.external_url_suffix}}:8443
      {% endif %}
      localmspid: {{ name }}MSP
            loglevel: info
            tlsstatus: true
            builder: hyperledger/fabric-ccenv:{{ network.version }}
            couchdb:
              username: {{ name }}-user

          storage:
            peer:
              storageclassname: {{ name }}sc
              storagesize: 512Mi
            couchdb:
              storageclassname: {{ name }}sc
              storagesize: 1Gi

          vault:
            role: vault-role
            address: {{ vault.url }}
            authpath: {{ network.env.type }}{{ namespace }}-auth
            secretprefix: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/peers/{{ peer_name }}.{{ namespace }}
            secretambassador: {{ vault.secret_path | default('secretsv2') }}/data/crypto/peerOrganizations/{{ namespace }}/ambassador
            serviceaccountname: vault-auth
            imagesecretname: regcred
            secretcouchdbpass: {{ vault.secret_path | default('secretsv2') }}/data/credentials/{{ namespace }}/couchdb/{{ name }}?user

          service:
            servicetype: ClusterIP
            ports:
              grpc:
                clusteripport: {{ peer.grpc.port }}
      {% if peer.grpc.nodePort is defined %}
                nodeport: {{ peer.grpc.nodePort }}
      {% endif %}
        events:
                clusteripport: {{ peer.events.port }}
      {% if peer.events.nodePort is defined %}
                nodeport: {{ peer.events.nodePort }}
      {% endif %}
        couchdb:
                clusteripport: {{ peer.couchdb.port }}
      {% if peer.couchdb.nodePort is defined %}
                nodeport: {{ peer.couchdb.nodePort }}
      {% endif %}
                
          proxy:
            provider: "{{ network.env.proxy }}"
            external_url_suffix: {{ item.external_url_suffix }}

          config:
            pod:
              resources:
                limits:
                  memory: 512M
                  cpu: 1
                requests:
                  memory: 512M
                  cpu: 0.5
  destination:
    server: "https://kubernetes.default.svc"
    namespace: {{ peer_ns}}
  syncPolicy:
    automated:
      # Do not enable pruning yet!
      prune: false # Specifies if resources should be pruned during auto-syncing ( false by default ).
      selfHeal: true
