import os
import gitlab
import datetime


gitlab_url = os.getenv("GITLAB_URL", "")
gitlab_token = os.getenv("GITLAB_PASSWORD", "")


with gitlab.Gitlab("https://" + gitlab_url, gitlab_token) as gl:
    items = gl.projects.list(iterator=True, statistics=True)
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
            if y.month < 7:
                print(pipedict["web_url"], pipedict["created_at"])
                pipeline.delete()
