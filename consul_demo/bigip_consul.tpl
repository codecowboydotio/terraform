{
    "class": "ADC",
    "schemaVersion": "3.7.0",
    "id": "urn:uuid:33045210-3ab8-4636-9b2a-c98d22ab425d",
    "label": "Consul Service Discovery",
    "Sample_consul_SD": {
      "class": "Tenant",
      "A1": {
        "class": "Application",
        "template": "generic",
        "service": {
          "class": "Service_HTTP",
          "virtualAddresses": [
            "${VIP_ADDRESS}"
          ],
          "pool": "web_pool"
        },
        "web_pool": {
          "class": "Pool",
          "monitors": [
            "http"
          ],
          "members": [
            {
              "servicePort": 80,
              "addressDiscovery": "consul",
              "updateInterval": 10,
              "uri": "http://52.63.229.58:8500/v1/catalog/service/web?passing",
              "credentialUpdate": false
            }
          ]
        }
      }
    }
}
