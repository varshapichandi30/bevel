{
    "display_name": "ordering node - {{ item.name | lower }}",
    "grpcwp_url": "https://{{ orderer.name }}-proxy.{{ component_ns }}:7443",
    "api_url": "grpcs://{{ orderer.name }}.{{ component_ns }}:7050",
    "operations_url": "http://{{ orderer.name }}-ops.{{ component_ns }}:7050",
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
