import os
import sys
import yaml
from gql import gql, Client
from gql.transport.aiohttp import AIOHTTPTransport

def read_config(configpath):
    yamlfile = open(configpath, "r")
    config = yaml.load(yamlfile, Loader=yaml.FullLoader)
    return config

def send_doc_by_config(host, headers, configpath):
    transport = AIOHTTPTransport(url=host, headers=headers)
    client = Client(transport=transport)
    config = read_config(configpath)
    query = gql(config["update_query"])
    documents = []
    for item in config["pages"]:
        f = open(item["path"], "r", encoding="utf-8")
        params = {
            "id": item["id"],
            "title": item["title"],
            "description": item["description"],
            "content": f.read()
        }
        documents.append(params)
    for document in documents:
        result = client.execute(query, variable_values=document)
        print(result)

def main():
    # get token
    token = os.getenv("WIKI_TOKEN")
    if token is not None:
        pass
    else:
        print("WIKI_TOKEN environment variable is None, exit...")
        sys.exit(1)
    headers = { "Authorization": "Bearer " + token }

    # get host
    host = os.getenv("WIKI_HOST") 
    if host is not None:
        host += "/graphql"
    else:
        print("WIKI_HOME ")
    if token is not None and host is not None:
        send_doc_by_config(host, headers, sys.argv[1])

main()
