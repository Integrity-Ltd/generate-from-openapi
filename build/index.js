"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fs_1 = __importDefault(require("fs"));
const handlebars_1 = __importDefault(require("handlebars"));
class CodeGenerator {
    constructor() {
        this.openapi = "";
        this.template = "";
        this.compiledTemplate = null;
        this.renderedTemplate = "";
        this.registerHelpers();
    }
    process() {
        this.initContext();
        fs_1.default.readdir('./templates', (err, files) => {
            files.forEach(file => {
                this.loadTemplate(file);
                this.renderTemplate();
                this.splitRenderedTemplateToFiles();
                if (file == 'crud-requests.tpl') {
                    this.updateOpenApiDeclaration();
                }
            });
        });
    }
    registerHelpers() {
        handlebars_1.default.registerHelper('isdefined', function (value) {
            return value !== undefined;
        });
        handlebars_1.default.registerHelper('capitalLower', function (value) {
            return value.charAt(0).toLowerCase() + value.slice(1);
        });
        handlebars_1.default.registerHelper('capitalUpper', function (value) {
            return value.charAt(0).toUpperCase() + value.slice(1);
        });
        handlebars_1.default.registerHelper('lowercase', function (value) {
            return value.toLowerCase();
        });
        handlebars_1.default.registerHelper('isexists', function (value, array) {
            return array.includes(value);
        });
        handlebars_1.default.registerHelper('startswith', function (value, pattern) {
            let result = value.startsWith(pattern);
            return result;
        });
        handlebars_1.default.registerHelper('endswith', function (value, pattern) {
            let result = value.endsWith(pattern);
            return result;
        });
        handlebars_1.default.registerHelper('slice', function (value, start, end) {
            let result = value.slice(start, end);
            return result;
        });
        handlebars_1.default.registerHelper('compare', function (lvalue, operator, rvalue) {
            if (arguments.length < 3) {
                throw new Error("Handlerbars Helper 'compare' needs 2 parameters");
            }
            let operators = {
                '==': function (l, r) { return l == r; },
                '===': function (l, r) { return l === r; },
                '!=': function (l, r) { return l != r; },
                '!==': function (l, r) { return l !== r; },
                '<': function (l, r) { return l < r; },
                '>': function (l, r) { return l > r; },
                '<=': function (l, r) { return l <= r; },
                '>=': function (l, r) { return l >= r; },
                'typeof': function (l, r) { return typeof l == r; }
            };
            if (!operators[operator]) {
                throw new Error("Handlerbars Helper 'compare' doesn't know the operator " + operator);
            }
            let result = operators[operator](lvalue, rvalue);
            return result;
        });
    }
    loadTemplate(file) {
        this.template = fs_1.default.readFileSync('./templates/' + file, 'utf8');
    }
    initContext() {
        if (process.argv.length > 2) {
            if (fs_1.default.existsSync(process.argv[2])) {
                this.openapi = fs_1.default.readFileSync(process.argv[2], 'utf8');
            }
            else {
                throw new Error("File " + process.argv[2] + " does not exist.");
            }
        }
        else {
            if (fs_1.default.existsSync('openapi.json')) {
                this.openapi = fs_1.default.readFileSync('openapi.json', 'utf8');
            }
            else {
                throw new Error("File openapi.json does not exist.");
            }
        }
        this.context = JSON.parse(this.openapi);
    }
    renderTemplate() {
        this.compiledTemplate = handlebars_1.default.compile(this.template);
        if (this.compiledTemplate) {
            this.renderedTemplate = this.compiledTemplate(this.context);
        }
    }
    splitRenderedTemplateToFiles() {
        let lines = this.renderedTemplate.split("\n");
        let linesInFile = [];
        let path = "";
        let fileName = "";
        lines.forEach((line) => {
            if (line.startsWith(">>>>>")) {
                const separatedPartInfo = line.split(" ");
                if (separatedPartInfo.length >= 3) {
                    path = separatedPartInfo[1];
                    fileName = separatedPartInfo[2].replace("\r", "");
                    linesInFile = [];
                }
                else if (separatedPartInfo.length == 1) {
                    if (!fs_1.default.existsSync(path)) {
                        fs_1.default.mkdir(path, { recursive: true }, () => {
                            console.log(`directory '${path}' created`);
                        });
                    }
                    fs_1.default.writeFileSync(path + fileName + (fs_1.default.existsSync(path + fileName + '.lock') ? '.backport' : ''), linesInFile.join("\n"));
                }
            }
            else {
                linesInFile.push(line);
            }
        });
    }
    updateOpenApiDeclaration() {
        if (fs_1.default.existsSync("./openapi-crud-requests.json")) {
            const crudOpenApi = fs_1.default.readFileSync("./openapi-crud-requests.json", 'utf8');
            const crudContext = JSON.parse(crudOpenApi);
            let methods = Object.keys(crudContext);
            methods.forEach((key) => {
                this.context['paths'][key] = crudContext[key];
            });
            fs_1.default.writeFileSync("../quiz-sample/openapi.json", JSON.stringify(this.context, null, 4));
        }
    }
}
try {
    let codeGenerator = new CodeGenerator();
    codeGenerator.process();
    console.log("Rendering to files finished.");
}
catch (err) {
    console.error(err);
}
