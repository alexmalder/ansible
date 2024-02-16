from fastapi import FastAPI
from fastapi import Depends
from fastapi_asyncpg import configure_asyncpg

import os

app = FastAPI()

def get_pg_connection_string():
    user=os.getenv("PG_USER")
    password=os.getenv("PG_PASSWORD")
    host=os.getenv("PG_HOST")
    database=os.getenv("PG_DB")
    connection_string = "postgresql://%s:%s@%s/%s" % (user, password, host, database)
    return connection_string

db = configure_asyncpg(app, get_pg_connection_string())

@db.on_init
async def initialization(conn):
    await conn.execute("SELECT 1")

@app.get("/")
async def read_root(db=Depends(db.connection)):
    data = await db.fetch("select get_student_with_courses_lf($1, $2, $3)", 128,0,"cv")
    return {"result": data}
