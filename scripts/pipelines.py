import os
import gitlab
import datetime


gitlab_url = os.getenv("GIT_URL_SECURE", "")
gitlab_token = os.getenv("GIT_PASSWORD_SECURE", "")

def test():
    with gitlab.Gitlab("https://" + gitlab_url, gitlab_token) as gl:
        items = gl.projects.list(search="DevOps")
        for repository in items:
            repo = repository.asdict()
            web_url = repo["web_url"]
            pipelines = repository.pipelines.list(get_all=True)
            for pipeline in pipelines:
                pipedict = pipeline.asdict()
                created_at = pipedict["created_at"]
                splitted = created_at.split("T")[0].split("-")
                y = datetime.datetime(
                    int(splitted[0]), int(splitted[1]), int(splitted[2])
                )
                if y.year < 2024:
                    print(pipedict["web_url"], pipedict["created_at"])
                    #pipeline.delete()

def test0():
    with gitlab.Gitlab("https://" + gitlab_url, gitlab_token) as gl:
        items = gl.projects.list(iterator=True, statistics=True)
        project_id = 10437
        project = gl.projects.get(project_id)
        repo = project.asdict()
        web_url = repo["web_url"]
        pipelines = project.pipelines.list(get_all=True)
        for pipeline in pipelines:
            pipedict = pipeline.asdict()
            created_at = pipedict["created_at"]
            splitted = created_at.split("T")[0].split("-")
            y = datetime.datetime(
                int(splitted[0]), int(splitted[1]), int(splitted[2])
            )
            print(pipedict["web_url"], pipedict["created_at"])
        pipeline.delete()

test()
