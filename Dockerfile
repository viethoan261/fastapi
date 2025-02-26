# Sử dụng image Python chính thức
FROM python:3.9

# Thiết lập thư mục làm việc
WORKDIR /app

# Thêm label để track version
ARG BUILD_DATE
ARG VERSION
LABEL build_date=$BUILD_DATE
LABEL version=$VERSION

# Copy requirements trước
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy source code sau
COPY . .

# Expose cổng mà FastAPI chạy
EXPOSE 8000

# Chạy ứng dụng FastAPI
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]