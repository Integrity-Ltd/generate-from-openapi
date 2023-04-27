>>>>> ./ openapi-crud-requests.json
{
{{#each components.schemas}}
    "/admin/crud/{{lowercase @key}}": {
      "get": {
        "summary": "Get all {{@key}}",
        "x-apidog-folder": "CRUD/{{@key}}",
        "x-apidog-status": "developing",
        "deprecated": false,
        "description": "",
        "tags": [],
        "parameters": [],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": {
                    "$ref": "#/components/schemas/{{@key}}"
                  }
                }
              }
            }
          }
        },
        "x-run-in-apidog": ""
      },
      "post": {
        "summary": "Save {{@key}}",
        "x-apidog-folder": "CRUD/{{@key}}",
        "x-apidog-status": "developing",
        "deprecated": false,
        "description": "",
        "tags": [],
        "parameters": [],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/{{@key}}"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/{{@key}}"
                }
              }
            }
          }
        },
        "x-run-in-apidog": ""
      }
    },
    "/admin/crud/{{lowercase @key}}/{id}": {
      "get": {
        "summary": "Get {{@key}}",
        "x-apidog-folder": "CRUD/{{@key}}",
        "x-apidog-status": "developing",
        "deprecated": false,
        "description": "",
        "tags": [],
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/{{@key}}"
                }
              }
            }
          }
        },
        "x-run-in-apidog": ""
      },
      "put": {
        "summary": "Update {{@key}}",
        "x-apidog-folder": "CRUD/{{@key}}",
        "x-apidog-status": "developing",
        "deprecated": false,
        "description": "",
        "tags": [],
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "requestBody": {
          "content": {
            "application/json": {
              "schema": {
                "$ref": "#/components/schemas/{{@key}}"
              }
            }
          }
        },
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "$ref": "#/components/schemas/{{@key}}"
                }
              }
            }
          }
        },
        "x-run-in-apidog": ""
      },
      "delete": {
        "summary": "Delete {{@key}}",
        "x-apidog-folder": "CRUD/{{@key}}",
        "x-apidog-status": "developing",
        "deprecated": false,
        "description": "",
        "tags": [],
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "description": "",
            "required": true,
            "schema": {
              "type": "string"
            }
          }
        ],
        "responses": {
          "200": {
            "description": "OK",
            "content": {
              "application/json": {
                "schema": {
                  "type": "null"
                }
              }
            }
          }
        },
        "x-run-in-apidog": ""
      }    
    }{{#unless @last}},{{/unless}}
{{/each}}
}
>>>>>