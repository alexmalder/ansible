import yaml
import sys

base_dn_people = "ou=people,dc=ldapmaster,dc=domain,dc=local"
base_dn_groups = "ou=groups,dc=ldapmaster,dc=domain,dc=local"


def objects_and_groups(config_openldap):
    people = []
    groups = []
    system = []
    for obj in config_openldap:
        split = obj.split(",")
        if len(split) == 5:
            if (
                len(obj.split(base_dn_people)) > 1
                and len(obj.split("infrastructure")) == 1
                and len(obj.split("service")) == 1
                and len(obj.split("wg")) == 1
            ):
                people.append(obj)
            elif len(obj.split(base_dn_groups)) > 1:
                groups.append(obj)
            elif len(obj.split("infrastructure")) > 1:
                system.append(obj)
            elif len(obj.split("wg.")) > 1:
                people.append(obj)
                system.append(obj)
                print(obj)
            #else:
               #print("UNHANDLED EXTRASTION FOR", obj)
        else:
            print("UNHANDLED EXTRASTION FOR", obj)
    return people, groups, system


def system_iterate(config_openldap, people, groups):
    system = {}
    system["networks"] = [
        "192.168.0.0/24",
        "192.168.1.0/24",
        "192.168.2.0/24",
        "10.10.10.10/24",
    ]
    system["hosts"] = []
    for user in people:
        dictionary = {}
        clean_user = user.replace("," + base_dn_people, "").split("=")[1]
        if len(clean_user.split("infrastructure.")) > 1:
            dictionary["hostname"] = clean_user.split("infrastructure.")[1]
        elif len(clean_user.split("wg.")) > 1:
            print(clean_user)
            dictionary["hostname"] = clean_user.split("wg.")[1]
        else:
            print("UNHANDLED IN SWITCH INFRA OR WG USER ACCOUNT TYPE")
        try:
            dictionary["allowed_ips"] = config_openldap[user]["l"][0]
        except:
            pass
        dictionary["groups"] = []
        for group in groups:
            if config_openldap[group]["cn"][0] == "dummy":
                pass
            else:
                members = config_openldap[group]["memberUid"]
                if clean_user in members:
                    clean_group = group.replace("," + base_dn_groups, "").split(
                        "="
                    )[1]
                    dictionary["groups"].append(clean_group)
        system["hosts"].append(dictionary)
    return system


def user_iterate(config_openldap, people, groups):
    users = []
    for user in people:
        dictionary = {}
        clean_user = user.replace("," + base_dn_people, "").split("=")[1]
        dictionary["username"] = clean_user
        try:
            dictionary["allowed_ips"] = config_openldap[user]["l"][0]
        except KeyError:
            pass
        try:
            dictionary["ssh_pubkey"] = config_openldap[user]["description"][0]
        except:
            pass
        try:
            dictionary["mail"] = config_openldap[user]["mail"][0]
        except:
            pass
        try:
            dictionary["public_key"] = config_openldap[user]["labeledURI"][0]
        except:
            pass
        dictionary["homeDirectory"] = config_openldap[user]["homeDirectory"][0]
        dictionary["loginShell"] = config_openldap[user]["loginShell"][0]
        dictionary["groups"] = []
        for group in groups:
            if config_openldap[group]["cn"][0] == "dummy":
                pass
            else:
                members = config_openldap[group]["memberUid"]
                if clean_user in members:
                    clean_group = group.replace("," + base_dn_groups, "").split("=")[1]
                    dictionary["groups"].append(clean_group)
        users.append(dictionary)
    return users


def main():
    inventory = sys.stdin
    config = yaml.load(inventory, Loader=yaml.Loader)
    config_openldap = config["openldap"]
    people, groups, system = objects_and_groups(config_openldap)
    inventory.close()
    users = user_iterate(config_openldap, people, groups)
    systems = system_iterate(config_openldap, system, groups)
    print("Users:", len(users))
    print("System:", len(systems))
    with open("vars/result.yml", "w") as file:
        print("USERS", users)
        yaml.dump({"wg_peers": users}, file)
    with open("vars/system.yml", "w") as file:
        print("SYSTEMS", systems)
        yaml.dump(systems, file)


main()
