from fastapi import FastAPI
import asyncpg

import os

app = FastAPI()

async def get_data_from_database():
    conn = await asyncpg.connect(
        user=os.getenv("PG_USER"),
        password=os.getenv("PG_PASSWORD"),
        database=os.getenv("PG_DATABASE"),
        host=os.getenv("PG_HOST")
    )
    result = await conn.fetch("select get_student_with_courses_lf($1, $2, $3)", 128, 0, "cv")
    await conn.close()
    return result


@app.get("/")
async def read_root():
    data = await get_data_from_database()
    return {"result": data}
