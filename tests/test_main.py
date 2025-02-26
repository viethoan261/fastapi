from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_read_root():
    response = client.get("/")
    assert response.status_code == 200

def test_read_item():
    response = client.get("/hello/Test")
    assert response.status_code == 200
