import os
import gitlab
import yaml


def iter_projects(gitlab_url, gl):
    items = []
    projects = gl.projects.list(iterator=True, statistics=True)
    for repository in projects:
        item = {}
        repo = repository.asdict()
        web_url = repo["web_url"]
        web_url = web_url.split(gitlab_url+"/")[1]
        item["name"] = web_url
        item["type"] = "project"
        variables = repository.variables.list(get_all=True)
        if len(variables) > 0:
            item["variables"] = []
            for variable in variables:
                variable = variable.asdict()
                item["variables"].append({variable["key"]: variable["value"]})
            items.append(item)
    return items


def iter_groups(gitlab_url, gl):
    items = []
    groups = gl.groups.list(get_all=True)
    for group in groups:
        item = {}
        group_dict = group.asdict()
        web_url = group_dict["web_url"]
        web_url = web_url.split(gitlab_url+"/groups/")[1]
        item["name"] = web_url
        item["type"] = "group"
        variables = group.variables.list()
        if len(variables) > 0:
            item["variables"] = []
            for variable in variables:
                variable = variable.asdict()
                item["variables"].append({variable["key"]: variable["value"]})
            items.append(item)
    return items


def main():
    gitlab_url = os.getenv("GITLAB_URL", "")
    gitlab_token = os.getenv("GITLAB_PASSWORD", "")
    gl = gitlab.Gitlab("https://" + gitlab_url, gitlab_token)
    group_variables = iter_groups(gitlab_url, gl)
    project_variables = iter_projects(gitlab_url, gl)
    with open("variables.yaml", "w") as f:
        yaml.dump(
            group_variables + project_variables,
            f,
            sort_keys=False,
            default_flow_style=False,
        )


main()
