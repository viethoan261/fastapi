# Sử dụng image Python chính thức
FROM python:3.9

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy requirements trước để tận dụng cache
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy source code sau
COPY . .

# Expose cổng mà FastAPI chạy
EXPOSE 8000

# Chạy ứng dụng FastAPI
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]