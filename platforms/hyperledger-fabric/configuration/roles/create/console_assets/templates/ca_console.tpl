{
    "display_name": "{{ item.type }}ca - {{ item.name | lower }}",
    "api_url": "https://{{ item.ca_data.url }}",
    "operations_url": "http://ca.{{ component_ns }}:7054",
    "ca_url": "https://{{ item.ca_data.url }}",
    "type": "fabric-ca",
    "ca_name": "ca.{{ component_ns }}",
    "tlsca_name": "ca.{{ component_ns }}",
    "tls_cert": "{{ ca_info.result.CAChain }}",
    "name": "{{ item.type }}ca - {{ item.name | lower }}"
}
