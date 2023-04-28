>>>>> ./ openapi-crud-requests.json
{
{{#each components.schemas}}
{{#if (startswith this.x-apidog-folder 'CRUD')}}
    "/admin/crud/{{lowercase @key}}": {
      "get": {
        "summary": "Get all {{@key}}",
        "x-apidog-folder": "CRUD/{{@key}}",
        "x-apidog-status": "developing",
        "deprecated": false,
        "description": "",
        "tags": ["{{@key}}"],
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
        "tags": ["{{@key}}"],
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
        "tags": ["{{@key}}"],
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
        "tags": ["{{@key}}"],
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
                  "$ref": "#/components/schemas/UpdateResult"
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
        "tags": ["{{@key}}"],
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
                  "$ref": "#/components/schemas/DeleteResult"
                }
              }
            }
          }
        },
        "x-run-in-apidog": ""
      }    
    }{{#unless @last}},{{/unless}}
{{/if}}
{{/each}}
}
>>>>>
