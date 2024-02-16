import os
import background
from termcolor import colored

# from git import Repo
# import gitlab

import requests

background.n=64

gitlab_url = os.getenv("GIT_URL_SECURE", "")
gitlab_token = os.getenv("GIT_PASSWORD_SECURE", "")

groups = [2363, 12655, 12106, 11710, 2267]

home = os.getenv("HOME", "")
workdir = home + "/Code"
try:
    os.mkdir(workdir)
except FileExistsError:
    print("workdir exists, skipping...")


@background.task
def clone_or_pull(web_url, repo_path):
    exists = os.path.isdir("%s/%s" % (workdir, repo_path))
    print(exists, repo_path)
    if not exists:
        clone_cmd = "git clone %s %s/%s" % (web_url, workdir, repo_path)
        print(clone_cmd)
        print(colored(clone_cmd, 'green'))
        os.system(clone_cmd)
        #repo = Repo.clone_from(web_url, workdir+"/"+repo_path)
        #print(repo)
    else:
        pull_cmd = "git -C %s/%s pull" % (workdir, repo_path)
        print(colored(pull_cmd, 'green'))
        os.system(pull_cmd)
        #repo = Repo(workdir+"/"+repo_path)
        #o = repo.remotes.origin
        #o.pull()
        #print(o)


def get_projects_by_group_id(group_id):
    response = requests.get(
        "https://"+gitlab_url+"/api/v4/groups/"+str(group_id)+"/projects?per_page=1024&include_subgroups=true", 
        headers={"PRIVATE-TOKEN": gitlab_token, "Content-Type": "application/json"}
    )
    return response.json()

def main():
    for group_id in groups:
        projects = get_projects_by_group_id(group_id)
        for project in projects:
          url = project["web_url"]
          rel_path = url.replace("https://"+gitlab_url+"/", "")
          clone_or_pull(url, rel_path)

main()

# with gitlab.Gitlab("https://" + gitlab_url, gitlab_token) as gl:
#     items = gl.projects.list(iterator=True)
#     for item in items:
#         repository = item.asdict()
#         print(repository)
#         url=repository["ssh_url_to_repo"]
#         clone_or_pull(repository["ssh_url_to_repo"], url.split("/")[-1])
