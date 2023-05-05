{{#each components.schemas}}
{{#if (startswith this.x-apidog-folder 'CRUD')}}
>>>>> ../quiz-admin/src/pages/ {{@key}}.tsx
import { useEffect, useState } from "react";
import { DataTable } from 'primereact/datatable';
import { Column } from 'primereact/column';

const {{@key}} = () => {
    const [{{capitalLower @key}}Values, set{{@key}}Values] = useState([]);

    useEffect(() => {
        fetchAll();
    }, []);

    const fetchAll = () => {
        fetch('/api/admin/crud/{{lowercase @key}}').then((response) => response.json()).then(data => {
            console.log(data);
            set{{@key}}Values(data);
        });
    }

    return (
        <div className="card flex">
            <div className="card">
                <DataTable value={ {{capitalLower @key}}Values } responsiveLayout="scroll">
                    <Column field="_id" header="ID"></Column>{{#each this.properties}}
                    <Column field="{{@key}}" header="{{capitalUpper @key}}"></Column>{{/each}}
                </DataTable>
            </div>
        </div>
    )
}

export default {{@key}};

>>>>>
{{/if}}
{{/each}}
>>>>> ../quiz-admin/src/components/ Nav.tsx
import { Menubar } from 'primereact/menubar';

const Navigation = () => {
    const navlist = [
        {
            label: 'Home', icon: 'pi pi-fw pi-home', command: () => {
                window.location.href = '/';
            }
        },
{{#each components.schemas}}
{{#if (startswith this.x-apidog-folder 'CRUD')}}
        {
            label: '{{@key}}', icon: 'pi pi-fw pi-calendar', command: () => {
                window.location.href = '/{{lowercase @key}}'
            }
        },
{{/if}}
{{/each}}
    ];

    return (
        <div>
            <header>
                <nav>
                    <Menubar
                        model={navlist}
                    />
                </nav>
            </header>
        </div>
    )
}
export default Navigation;
>>>>>