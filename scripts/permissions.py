import os
import gitlab

gitlab_url = os.getenv("GIT_URL_SECURE", "")
gitlab_token = os.getenv("GIT_PASSWORD_SECURE", "")

def iter_item(items):
    for project in items:
        members_by_project = project.members.list(get_all=True)
        project_dict = project.asdict()
        print(project_dict["web_url"]+":")
        for membership in members_by_project:
            memberdict = membership.asdict()
            print("  - "+memberdict["username"] + ":" + str(memberdict["access_level"]))


with gitlab.Gitlab("https://" + gitlab_url, gitlab_token) as gl:
    iter_item(gl.projects.list(get_all=True, owned=True))
    iter_item(gl.groups.list(get_all=True, owned=True))
