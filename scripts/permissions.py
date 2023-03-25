import os
import gitlab
import yaml

gitlab_url = os.getenv("GIT_URL_SECURE", "")
gitlab_token = os.getenv("GIT_PASSWORD_SECURE", "")

items = []
with gitlab.Gitlab("https://" + gitlab_url, gitlab_token) as gl:
    users = gl.users.list()
    for user in users:
        dictionary = {}
        memberships = user.memberships.list(get_all=True)
        user_dict = user.asdict()
        dictionary["username"] = user_dict["username"]
        dictionary["services"] = []
        for membership in memberships:
            member_dict = membership.asdict()
            dictionary["services"].append(
                {
                    "source_name": member_dict["source_name"],
                    "access_level": member_dict["access_level"],
                    "source_type": member_dict["source_type"],
                }
            )
        items.append(dictionary)

print(items)

with open('permissions.yaml', 'w') as f:
    yaml.dump(items, f, sort_keys=False, default_flow_style=False)
