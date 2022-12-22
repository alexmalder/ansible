from aiochclient import ChClient
from aiohttp import ClientSession
import asyncio
import os
import datetime
import json

query_container_get = "SELECT distinct(container_image_name) from auditbeat_daily where container_image_name like '%nexus%'"


def get_connection_string():
    ch_user = os.getenv("CLICKHOUSE_USER")
    ch_password = os.getenv("CLICKHOUSE_PASSWORD")
    ch_host = os.getenv("CLICKHOUSE_HOST")
    ch_port = os.getenv("CLICKHOUSE_PORT")
    ch_db = os.getenv("CLICKHOUSE_DB")
    conn_str = "clickhouse://%s:%s@%s:%s/%s" % (
        ch_user,
        ch_password,
        ch_host,
        ch_port,
        ch_db,
    )
    return conn_str


def query_dest_ip(container):
    return (
        "select distinct(destination_domain) from auditbeat_daily where container_image_name like '%"
        + container
        + "%'"
    )

async def clean():
    print(datetime.datetime.now())
    async with ClientSession() as s:
        client = ChClient(s, url=get_connection_string(), allow_experimental_lightweight_delete=1)
        #assert await client.is_alive()
        query = "delete from auditbeat_daily where timestamp < " + str(datetime.date(2022, 10, 1))
        await client.fetchone("alter table auditbeat_daily delete where timestamp < '2022-10-01 00:00:00'")

async def main():
    workdict = {}
    async with ClientSession() as s:
        client = ChClient(s, url=get_connection_string())
        assert await client.is_alive()
        dest_ips_by_container = []
        containers = []
        async for row_container_image_name in client.iterate(query_container_get):
            container_image_name = row_container_image_name.get(
                "container_image_name"
            ).split(":")[0]
            containers.append(container_image_name)
        containers = set(containers)
        for container in containers:
            workdict[container]=[]
            query_dest_ip = (
                "select distinct(destination_domain) from auditbeat_daily where container_image_name like '%"
                + container
                + "%'"
            )

            async for row_dest_ip in client.iterate(query_dest_ip):
                destination_domain = row_dest_ip.get("destination_domain")
                dest_ips_by_container.append(destination_domain)

            for destination_domain in dest_ips_by_container:
                if destination_domain is not None:
                    workdict[container].append(destination_domain)
                    #print("%s -> %s" % (container, destination_domain), flush=True)
    print(json.dumps(workdict))

loop = asyncio.get_event_loop()
loop.run_until_complete(main())
