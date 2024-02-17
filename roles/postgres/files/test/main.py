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
    f = open('./init.sql', 'r')
    init_sql = f.read()
    print(init_sql)
    await conn.execute(init_sql)
    f.close()
    await conn.execute("SELECT 1")

@app.get("/courses/students")
async def read_root(db=Depends(db.connection)):
    data = await db.fetch("select get_student_with_courses_lf($1, $2, $3)", 128, 0, "cv")
    return {"data": data}

@app.get("/courses")
async def select_courses(db=Depends(db.connection)):
    data = await db.fetch("select select_courses_lf($1, $2)", 128, 0)
    return {"data": data}

@app.post("/courses")
async def insert_course(item: Item, db=Depends(db.connection)):
    data = await db.fetch("select insert_course($1)", item.name)
    return {"data": data}

@app.put("/courses/{item_id}")
async def update_course(item_id: int, item: Item, db=Depends(db.connection)):
    data = await db.fetch("select update_course($1, $2)", item_id, item.name)
    return {"data": data}

@app.delete("/courses/{item_id}")
async def delete_course(item_id: int, db=Depends(db.connection)):
    data = await db.fetch("select delete_course($1)", item_id)
    return {"data": data}
