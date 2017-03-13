


1. list-application-attributes.jsonschema
=========================================
Modified:
                                "lower": {
                                  "items": [], 
                                  "type": "array"
                                }
TO:

                                "lower": {
                                  "items": [
                                    {
                                      "type": "string"
                                    }
                                  ], 
                                  "type": "array"
                                }

2. get-app-package-info_ingestion.jsonschema:
============================================
Modified:
      "items": [], 
TO:
      "items": [
        {
          "type": "string"
        }
      ],
 
3. get-app-package-operator-properties.jsonschema:
==================================================
Modified:
    "outputPorts": {
      "items": [
        {
          "required": [
            "description",
            "error",
            "name",
            "optional"
          ],
TO:
    "outputPorts": {
      "items": [
        {
          "required": [
            "error",
            "name",
            "optional"
          ],
--------------------------------------------------
Modified:
    "inputPorts": {
      "items": [
        {
          "type": "string"
        }
TO:
    "inputPorts": {
      "items": [
        {
          "type": "object",
          "properties": {
            "optional": {
              "type": "boolean"
            },
            "name": {
              "type": "string"
            }
          }
        }

4. get-app-package-info_pi-demo.jsonschema
Modified:
	Required: 
                            "CUSTOM_METRIC_AGGREGATOR",
                            "CUSTOM_METRIC_DIMENSIONS_SCHEME",
To:
	Not required
