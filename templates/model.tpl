{{#each components.schemas}}
>>>>> ../quiz-sample/src/models/ {{@key}}.ts
import { Schema, model, Types } from "mongoose";
import Joi from "joi";

const {{capitalLower @key}}Schema = new Schema({ {{#each this.properties}}{{#unless (startwith @key '_')}}
            {{@key}}: {
                type: {{#if (endswith @key '_id')}}Types.ObjectId{{else}}{{capitalUpper this.type}}{{/if}},
                required:{{#if (isexists @key ../required)}}true{{else}}false{{/if}},
            },{{/unless}}{{/each}}
});

const {{@key}} = model("{{lowercase @key}}", {{capitalLower @key}}Schema);

const validate = ({{lowercase @key}}: object): Joi.ValidationResult => {
    const schema = Joi.object().keys({ {{#each this.properties}}{{#unless (startwith @key '_')}}
        {{@key}}: Joi.{{this.type}}(){{#if (isexists @key ../required)}}.required(){{/if}},{{/unless}}{{/each}}
    });
    return schema.validate({{lowercase @key}});
};

export default { {{@key}}, validate };
>>>>>
>>>>> ../quiz-sample/src/routes/ route{{@key}}.ts
import { Router } from "express";
import {{@key}} from "../models/{{@key}}";
import { Condition, ObjectId, UpdateWriteOpResult } from "mongoose";
import Joi from "joi";
const router = Router();

router.get("/:id", async (req, res) => {
    let result = await {{@key}}.{{@key}}.find({ _id: req.params.id })
    res.send(result);
})

router.delete("/:id", async (req, res) => {
    let result = await {{@key}}.{{@key}}.deleteOne({ _id: req.params.id })
    res.send(result);
})

router.put("/:id", async (req, res) => {
    let valid: Joi.ValidationResult = {{@key}}.validate(req.body);
    if (!valid.error) {
        const filter: Condition<ObjectId> = { _id: req.params.id };
        const updateDoc = {
            $set: req.body
        }
        let result: UpdateWriteOpResult = await {{@key}}.{{@key}}.updateOne(filter, updateDoc);
        res.send(result);
    } else {
        res.status(400).send({ message: valid.error })
    }
})

router.post("/", async (req, res) => {
    let valid: Joi.ValidationResult = {{@key}}.validate(req.body);
    if (!valid.error) {
        let {{capitalLower @key}} = new {{@key}}.{{@key}}(req.body);
        {{capitalLower @key}}.save().then(() =>
            res.send({{capitalLower @key}})
        );
    } else {
        res.status(400).send({ message: valid.error })
    }
})

export default router;
>>>>>
{{/each}}

>>>>> ./ openapi-crud-requests.json
{
{{#each components.schemas}}
    "/{{lowercase @key}}/crud": {
      "post": {
        "summary": "Save {{@key}}",
        "x-apidog-folder": "",
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
        "x-run-in-apidog": "https://www.apidog.com/web/project/362580/apis/api-3713731-run"
      }
    },
    "/{{lowercase @key}}/crud/{id}": {
      "get": {
        "summary": "Get {{@key}}",
        "x-apidog-folder": "",
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
        "x-run-in-apidog": "https://www.apidog.com/web/project/362580/apis/api-3717087-run"
      },
      "put": {
        "summary": "Update {{@key}}",
        "x-apidog-folder": "",
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
        "x-run-in-apidog": "https://www.apidog.com/web/project/362580/apis/api-3717090-run"
      },
      "delete": {
        "summary": "Delete {{@key}}",
        "x-apidog-folder": "",
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
        "x-run-in-apidog": "https://www.apidog.com/web/project/362580/apis/api-3717092-run"
      }    
    }{{#unless @last}},{{/unless}}
{{/each}}
}
>>>>>