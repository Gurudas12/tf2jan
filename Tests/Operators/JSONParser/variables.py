#Schemas
valid_schema_all_req = """{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "Product set",
  "type": "object",
  "properties": {
    "adId": {
      "description": "Advertisement ID",
      "type": "integer",
      "minimum": 1,
      "maximum": 5,
      "exclusiveMinimum": false
    },
    "campaignName": {
      "type": "string"
    },
    "campaignBudget": {
      "type": "number"
    },
    "weatherTargeting": {
      "type": "boolean"
    }
  },
  "required": [
    "adId",
    "campaignName",
    "campaignBudget",
    "weatherTargeting"
  ]
}"""
valid_schema_few_req = """{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "Product set",
  "type": "object",
  "properties": {
    "adId": {
      "description": "Advertisement ID",
      "type": "integer",
      "minimum": 1,
      "maximum": 5,
      "exclusiveMinimum": false
    },
    "campaignName": {
      "type": "string"
    },
    "campaignBudget": {
      "type": "number"
    },
    "weatherTargeting": {
      "type": "boolean"
    }
  },
  "required": [
    "adId",
    "campaignName"
  ]
}"""
valid_schema_no_req = """{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "Product set",
  "type": "object",
  "properties": {
    "adId": {
      "description": "Advertisement ID",
      "type": "integer",
      "minimum": 1,
      "maximum": 5,
      "exclusiveMinimum": false
    },
    "campaignName": {
      "type": "string"
    },
    "campaignBudget": {
      "type": "number"
    },
    "weatherTargeting": {
      "type": "boolean"
    }
  }
}"""
valid_schema_with_extra_field = """{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "Product set",
  "type": "object",
  "properties": {
    "adId": {
      "description": "Advertisement ID",
      "type": "integer",
      "minimum": 1,
      "maximum": 5,
      "exclusiveMinimum": false
    },
    "campaignName": {
      "type": "string"
    },
    "campaignBudget": {
      "type": "number"
    },
    "weatherTargeting": {
      "type": "boolean"
    },
    "extraField": {
      "type": "boolean"
    }
  },
  "required": [
    "adId",
    "campaignName",
    "campaignBudget",
    "weatherTargeting"
  ]
}"""
invalid_schema_with_extra_req_field = """{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "Product set",
  "type": "object",
  "properties": {
    "adId": {
      "description": "Advertisement ID",
      "type": "integer",
      "minimum": 1,
      "maximum": 5,
      "exclusiveMinimum": false
    },
    "campaignName": {
      "type": "string"
    },
    "campaignBudget": {
      "type": "number"
    },
    "weatherTargeting": {
      "type": "boolean"
    },
    "extraField": {
      "type": "boolean"
    }
  },
  "required": [
    "adId",
    "campaignName",
    "campaignBudget",
    "weatherTargeting",
    "extraField"
  ]
}"""

invalid_schema_all_caps = """{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "title": "Product set",
  "type": "object",
  "properties": {
    "ADID": {
      "description": "Advertisement ID",
      "type": "integer",
      "minimum": 1,
      "maximum": 5,
      "exclusiveMinimum": false
    },
    "CAMPAIGNNAME": {
      "type": "string"
    },
    "CAMPAIGNBUDGET": {
      "type": "number"
    },
    "WEATHERTARGETING": {
      "type": "boolean"
    }
  },
  "required": [
    "ADID",
    "CAMPAIGNNAME",
    "CAMPAIGNBUDGET",
    "WEATHERTARGETING"
  ]
}"""

invalid_schema_all_missing = """{
  "title": "Product set",
  "type": "object",
  "properties": {
    "A": {  "type": "integer"  },
    "B": {  "type": "string"  },
    "C": {  "type": "number"  },
    "D": {  "type": "boolean"  }
  },
  "required": [
    "A","B","C","D"
  ]
}"""
