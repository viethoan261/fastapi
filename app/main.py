from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def read_root():
    return {"message": "hahaha!"}

@app.get("/hello/{name}")
async def read_item(name: str):
    return {"message": f"Xin chào, {name}!"} 