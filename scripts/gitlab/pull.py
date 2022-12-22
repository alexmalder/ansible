import os
import background
import gitlab

background.n=64

gitlab_url = os.getenv("GITLAB_URL", "")
gitlab_token = os.getenv("GITLAB_PASSWORD", "")
home = os.getenv("HOME", "")
workdir = home + "/Gitlab"
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
    items = gl.projects.list(iterator=True, statistics=True)
    for item in items:
        repository = item.asdict()
        # print(repository)
        web_url = repository["web_url"]
        size = repository["statistics"]["repository_size"] / 1024 / 1024
        #clone_or_pull(web_url, web_url.split("/")[-1])
        if size < 256:
            clone_or_pull(web_url, web_url.split(gitlab_url+"/")[1])
