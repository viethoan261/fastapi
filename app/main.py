from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def read_root():
    return {"message": "vai l luon!"}

@app.get("/hello/{name}")
async def read_item(name: str):
    return {"message": f"Xin chào, {name}!"} 