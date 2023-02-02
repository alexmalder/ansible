import os
import background
from pprint import pprint
import gitlab

#background.n=8

gitlab_url = os.getenv("GITLAB_URL", "")
gitlab_token = os.getenv("GITLAB_PASSWORD", "")
home = os.getenv("HOME", "")
workdir = home + "/Code"
try:
    os.mkdir(workdir)
except FileExistsError:
    print("workdir exists, skipping...")


#@background.task
def clone_or_pull(web_url, repo_name):
    dirs = os.listdir(workdir)
    if repo_name in dirs:
        print("repository cloned")
        pull_cmd = "git -C %s/%s pull" % (workdir, repo_name)
        print(pull_cmd)
        os.system(pull_cmd)
    else:
        print("clone start")
        clone_cmd = "git clone %s %s/%s" % (web_url, workdir, repo_name)
        print(clone_cmd)
        os.system(clone_cmd)


with gitlab.Gitlab("https://" + gitlab_url, gitlab_token) as gl:
    projects = gl.projects.list(iterator=True, owned=True)
    for project in projects:
        repository = project.asdict()
        url=repository["ssh_url_to_repo"]
        statistics = project.additionalstatistics.get()
        print(statistics)
        #pprint(repository)
        clone_or_pull(repository["ssh_url_to_repo"], url.split("/")[-1])
