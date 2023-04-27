{{#each components.schemas}}
{{#if (startswith this.x-apidog-folder 'CRUD')}}
>>>>> ../quiz-sample/src/models/ {{@key}}.ts
import { Schema, model, Types } from "mongoose";
import Joi from "joi";

const {{capitalLower @key}}Schema = new Schema({ {{#each this.properties}}
            {{@key}}: {
                type: {{#if (endswith @key '_id')}}Types.ObjectId{{else}}{{#if (endswith @key '_time')}}Date{{else}}{{capitalUpper this.type}}{{/if}}{{/if}},
                required:{{#if (isexists @key ../required)}}true{{else}}false{{/if}},
            },{{/each}}
});

const {{@key}} = model("{{lowercase @key}}", {{capitalLower @key}}Schema);

const validate = ({{lowercase @key}}: object): Joi.ValidationResult => {
    const schema = Joi.object().keys({ {{#each this.properties}}{{#unless (startswith @key '_')}}
        {{@key}}: Joi.{{#if (endswith @key '_time')}}date{{else}}{{this.type}}{{/if}}(){{#if (isexists @key ../required)}}.required(){{/if}},{{/unless}}{{/each}}
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

router.get("/", async (req, res) => {
    let result = await {{@key}}.{{@key}}.find({})
    res.send(result);
})

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
{{/if}}
{{/each}}