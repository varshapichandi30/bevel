{
    "display_name": "ordering node - {{ item.name | lower }}",
    "grpcwp_url": "https://{{ orderer.name }}-proxy:7050",
    "api_url": "grpcs://{{ orderer.name }}:7050",
    "operations_url": "https://{{ orderer.name }}-ops:9443",
    "type": "fabric-orderer",
    "msp_id": "{{ item.name | lower }}MSP",
    "system_channel_id": "syschannel",    
    "cluster_id": "orderer_supplychain_raft",
    "cluster_name": "orderer_supplychain",
    "name": "ordering node - {{ item.name | lower }}",
    "msp": {
        "component": {
            "tls_cert": "{{ ca_info.result.CAChain }}"
        },
        "ca": {
            "root_certs": [
                "{{ ca_info.result.CAChain }}"
            ]
        },
        "tlsca": {
            "root_certs": [
                "{{ ca_info.result.CAChain }}"
            ]
        }
    },
    "pem": "{{ ca_info.result.CAChain }}",
    "tls_cert": "{{ ca_info.result.CAChain }}",
    "tls_ca_root_cert": "{{ ca_info.result.CAChain }}"
}
