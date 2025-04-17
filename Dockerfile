# Sử dụng Alpine làm base image
FROM alpine:latest

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói hệ thống cơ bản từ mirror TQ cho apk
RUN apk add --no-cache npm nodejs bash curl

# Cài đặt các package Node.js từ registry mặc định của npm
RUN npm install colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api express localtunnel

# Sao chép mã nguồn vào container
COPY . . 

# Cấp quyền thực thi cho các file
RUN chmod +x ./*
# Chạy script start.sh
RUN /NeganConsole/start.sh
