import fs from 'fs'
import Handlebars from 'handlebars'
require("dotenv").config();

class GeneratedFiles {
    private _path: string = "";
    private _fileName: string = "";
    public get path(): string {
        return this._path;
    }
    public get fileName(): string {
        return this._fileName;
    }
    constructor(path: string, fileName: string) {
        this._path = path;
        this._fileName = fileName;
    }
}

class CodeGenerator {
    private context: any;
    private openapi: string = "";
    private template: string = "";
    private compiledTemplate: HandlebarsTemplateDelegate<any> | null = null;
    private renderedTemplate: string = "";
    private outputs: GeneratedFiles[] = [];

    constructor() {
        this.registerHelpers();
    }

    public process() {
        this.initContext();
        const templatesPath = process.argv.length > 3 ? process.argv[3] : './templates';
        fs.readdir(templatesPath, (err, files) => {
            files.forEach(file => {
                if (file.endsWith('.hbs')) {
                    this.loadTemplate(file);
                    this.renderTemplate();
                    this.splitRenderedTemplateToFiles();
                    if (file == 'crud-requests.hbs') {
                        this.outputs.filter((output: GeneratedFiles) => output.fileName == 'openapi-crud-requests.json').
                            map((output: GeneratedFiles) => {
                                this.updateOpenApiDeclaration(output.path + output.fileName);
                            })
                    }
                }
            })
        })
    }

    private registerHelpers() {
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
        Handlebars.registerHelper('startswith', function (value, pattern) {
            let result = value.startsWith(pattern);
            return result;
        });
        Handlebars.registerHelper('endswith', function (value, pattern) {
            let result = value.endsWith(pattern);
            return result;
        });
        Handlebars.registerHelper('slice', function (value, start, end) {
            let result = value.slice(start, end);
            return result;
        });
        Handlebars.registerHelper('compare', function (lvalue: any, operator: any, rvalue: any) {
            if (arguments.length < 3) {
                throw new Error("Handlerbars Helper 'compare' needs 2 parameters");
            }
            let operators: any = {
                '==': function (l: any, r: any) { return l == r; },
                '===': function (l: any, r: any) { return l === r; },
                '!=': function (l: any, r: any) { return l != r; },
                '!==': function (l: any, r: any) { return l !== r; },
                '<': function (l: any, r: any) { return l < r; },
                '>': function (l: any, r: any) { return l > r; },
                '<=': function (l: any, r: any) { return l <= r; },
                '>=': function (l: any, r: any) { return l >= r; },
                'typeof': function (l: any, r: any) { return typeof l == r; }
            };

            if (!operators[operator]) {
                throw new Error("Handlerbars Helper 'compare' doesn't know the operator " + operator);
            }

            let result = operators[operator](lvalue, rvalue);
            return result;
        });
    }

    private loadTemplate(file: string) {
        const templatesPath = process.argv.length > 3 ? process.argv[3] : './templates';
        this.template = fs.readFileSync(templatesPath + '/' + file, 'utf8');
    }

    private initContext() {
        if (process.argv.length > 2) {
            if (fs.existsSync(process.argv[2])) {
                this.openapi = fs.readFileSync(process.argv[2], 'utf8');
            } else {
                throw new Error("File " + process.argv[2] + " does not exist.");
            }
        } else {
            if (fs.existsSync('openapi.json')) {
                this.openapi = fs.readFileSync('openapi.json', 'utf8');
            } else {
                throw new Error("File openapi.json does not exist.");
            }
        }
        this.context = JSON.parse(this.openapi);
    }

    private renderTemplate() {
        this.compiledTemplate = Handlebars.compile(this.template);
        if (this.compiledTemplate) {
            this.renderedTemplate = this.compiledTemplate(this.context)
        }
    }

    private splitRenderedTemplateToFiles() {
        let lines = this.renderedTemplate.split("\n");
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
                        fs.mkdirSync(path, { recursive: true });
                        console.log(`directory '${path}' created`)
                    }
                    this.outputs.push(new GeneratedFiles(path, fileName));
                    fs.writeFileSync(path + fileName + (fs.existsSync(path + fileName + '.lock') ? '.backport' : ''), linesInFile.join("\n"));
                }
            } else {
                linesInFile.push(line);
            }
        });
    }

    public updateOpenApiDeclaration(generatedFileName: string) {
        if (fs.existsSync(generatedFileName)) {
            const crudOpenApi = fs.readFileSync(generatedFileName, 'utf8');
            const crudContext = JSON.parse(crudOpenApi);
            let methods = Object.keys(crudContext);
            methods.forEach((key) => {
                this.context['paths'][key] = crudContext[key];
            })
            const updatedOpenApiFile: string | undefined = process.env.FOR_UPDATE_OPENAPI_FILE;
            if (updatedOpenApiFile && fs.existsSync(updatedOpenApiFile)) {
                fs.writeFileSync(updatedOpenApiFile, JSON.stringify(this.context, null, 4));
            }
        }

    }
}

try {
    let codeGenerator: CodeGenerator = new CodeGenerator();
    codeGenerator.process();
    console.log("Rendering to files finished.")
} catch (err) {
    console.error(err);
}