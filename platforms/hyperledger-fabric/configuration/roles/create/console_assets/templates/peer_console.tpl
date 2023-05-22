{
    "display_name": "{{ component_name }} - local",
    "grpcwp_url": "https://{{ peer.name }}.{{ component_ns }}:7443",
    "api_url": "grpcs://{{ peer.name }}.{{ component_ns }}:7051",
    "operations_url": "http://{{ peer.name }}.{{ component_ns }}:9443",
    "msp_id": "{{ item.name | lower }}MSP",
    "name": "{{ component_name }} - local",
    "type": "fabric-peer",
    "msp": {
        "component": {
            "admin_certs": [],
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
