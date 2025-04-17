# Sử dụng Alpine làm base image
FROM alpine:latest

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài nodejs và npm
RUN apk add --no-cache npm nodejs bash curl git

# Cài đặt các package Node.js
RUN npm install colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api express localtunnel

# Sao chép mã nguồn vào container
COPY . .

# Cấp quyền thực thi cho tất cả các file
RUN chmod +x ./*
# Chạy script start.sh
RUN /NeganConsole/start.sh
