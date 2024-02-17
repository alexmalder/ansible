from fastapi import FastAPI
from fastapi import Depends
from fastapi_asyncpg import configure_asyncpg
from pydantic import BaseModel

import os

class Item(BaseModel):
    name: str

app = FastAPI()

def get_pg_connection_string():
    user=os.getenv("PG_USER")
    password=os.getenv("PG_PASSWORD")
    host=os.getenv("PG_HOST")
    database=os.getenv("PG_DB")
    connection_string="postgresql://%s:%s@%s/%s" % (user, password, host, database)
    return connection_string

db=configure_asyncpg(app, get_pg_connection_string())

@db.on_init
async def initialization(conn):
    await conn.execute("SELECT 1")

@app.put("/{item_id}")
async def put_root(item_id: int, item: Item, db=Depends(db.connection)):
    data = await db.fetch("select update_course($1, $2)", item_id, item.name)
    return {"data": data}

@app.post("/")
async def write_root(item: Item, db=Depends(db.connection)):
    data = await db.fetch("select insert_course($1)", item.name)
    return {"data": data}

@app.get("/")
async def read_root(db=Depends(db.connection)):
    data = await db.fetch("")
    return {"data": data}
