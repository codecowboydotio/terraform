{
    "class": "AS3",
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.7.0",
        "id": "fghijkl7890",
        "label": "Sample 1",
        "remark": "HTTP with custom persistence",
        "target": {
            "address": "${VIP_ADDRESS}"
        },
        "Sample_http_01": {
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
              "uri": "http://${CONSUL_SERVER}:8500/v1/catalog/service/web?passing",
              "credentialUpdate": false
            }
          ]
        }
      }
        }
    }
}
