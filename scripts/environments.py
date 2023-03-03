import os
import gitlab
import yaml
import base64


def iter_projects(gitlab_url, gl):
    items = []
    projects = gl.projects.list(iterator=True, statistics=True, owned=True)
    for repository in projects:
        item = {}
        repo = repository.asdict()
        web_url = repo["web_url"]
        web_url = web_url.split(gitlab_url + "/")[1]
        item["name"] = web_url
        item["type"] = "project"
        variables = repository.variables.list(get_all=True)
        if len(variables) > 0:
            item["variables"] = []
            for variable in variables:
                variable = variable.asdict()
                if variable["variable_type"] == "env_var":
                    item["variables"].append({variable["key"]: variable["value"]})
                elif variable["variable_type"] == "file":
                    byteval = variable["value"].encode("utf-8")
                    encoded_val = base64.b64encode(byteval).decode("utf-8")
                    item["variables"].append({variable["key"]: encoded_val})
            items.append(item)
    return items


def iter_groups(gitlab_url, gl):
    items = []
    groups = gl.groups.list(get_all=True, owned=True)
    for group in groups:
        item = {}
        group_dict = group.asdict()
        web_url = group_dict["web_url"]
        web_url = web_url.split(gitlab_url + "/groups/")[1]
        item["name"] = web_url
        item["type"] = "group"
        variables = group.variables.list()
        if len(variables) > 0:
            item["variables"] = []
            for variable in variables:
                variable = variable.asdict()
                if variable["variable_type"] == "env_var":
                    item["variables"].append({variable["key"]: variable["value"]})
                elif variable["variable_type"] == "file":
                    byteval = variable["value"].encode("utf-8")
                    encoded_val = base64.b64encode(byteval).decode("utf-8")
                    item["variables"].append({variable["key"]: encoded_val})

            items.append(item)
    return items


def main():
    gitlab_url = os.getenv("GIT_URL_SECURE", "")
    gitlab_token = os.getenv("GIT_PASSWORD_SECURE", "")
    gl = gitlab.Gitlab("https://" + gitlab_url, gitlab_token)
    group_variables = iter_groups(gitlab_url, gl)
    project_variables = iter_projects(gitlab_url, gl)
    print(yaml.safe_dump({"groups": group_variables, "projects": project_variables}))


main()
