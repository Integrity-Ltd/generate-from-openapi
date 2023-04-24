import fs from 'fs'
import Handlebars from 'handlebars'
try {
    Handlebars.registerHelper('isdefined', function (value) {
        return value !== undefined;
    });
    Handlebars.registerHelper('capitalLower', function (value) {
        return value.charAt(0).toLowerCase() + value.slice(1);
    });
    Handlebars.registerHelper('capitalUpper', function (value) {
        return value.charAt(0).toUpperCase() + value.slice(1);
    });
    Handlebars.registerHelper('lowercase', function (value) {
        return value.toLowerCase();
    });
    Handlebars.registerHelper('isexists', function (value, array) {
        return array.includes(value);
    });
    Handlebars.registerHelper('startwith', function (value, pattern) {
        let result = value.startsWith(pattern);
        return result;
    });
    Handlebars.registerHelper('endswith', function (value, pattern) {
        let result = value.endsWith(pattern);
        return result;
    });

    const template = fs.readFileSync('./templates/model.tpl', 'utf8');
    const openapi = fs.readFileSync('openapi.json', 'utf8');
    const context = JSON.parse(openapi);
    let compiledTemplate: HandlebarsTemplateDelegate<any> = Handlebars.compile(template);
    let renderedTemplate = compiledTemplate(context);
    let lines = renderedTemplate.split("\n");
    let linesInFile: string[] = [];
    let path = "";
    let fileName = "";
    lines.forEach((line) => {
        if (line.startsWith(">>>>>")) {
            const separatedPartInfo = line.split(" ");
            if (separatedPartInfo.length >= 3) {
                path = separatedPartInfo[1];
                fileName = separatedPartInfo[2].replace("\r", "");
                linesInFile = []
            } else if (separatedPartInfo.length == 1) {
                if (!fs.existsSync(path)) {
                    fs.mkdir(path, { recursive: true }, () => {
                        console.log(`directory '${path}' created`)
                    });
                }
                fs.writeFileSync(path + fileName + (fs.existsSync(path + fileName + '.lock') ? '.backport' : ''), linesInFile.join("\n"));
            }
        } else {
            linesInFile.push(line);
        }
    });
    if (fs.existsSync("./openapi-crud-requests.json")) {
        const crudOpenApi = fs.readFileSync("./openapi-crud-requests.json", 'utf8');
        const crudContext = JSON.parse(crudOpenApi);
        let methods = Object.keys(crudContext);
        methods.forEach((key) => {
            context['paths'][key] = crudContext[key];
        })
        fs.writeFileSync("../quiz-sample/openapi.json", JSON.stringify(context, null, 4));
    }
    console.log("Rendering to files finished.")
} catch (err) {
    console.error(err);
}