# Sử dụng Alpine làm base image
FROM alpine:latest

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói hệ thống cơ bản từ mirror TQ cho apk
RUN apk add --no-cache npm nodejs bash curl

# Cài đặt các package Node.js từ registry mặc định của npm
RUN npm install --omit=dev colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api localtunnel --silent && \
    rm -rf /root/.npm



# Tăng toàn bộ giới hạn `ulimit` lên `unlimited` trong profile của container khi chạy
RUN echo '* soft nofile unlimited' >> /etc/security/limits.conf && \
    echo '* hard nofile unlimited' >> /etc/security/limits.conf && \
    echo '* soft nproc unlimited' >> /etc/security/limits.conf && \
    echo '* hard nproc unlimited' >> /etc/security/limits.conf && \
    echo '* soft stack unlimited' >> /etc/security/limits.conf && \
    echo '* hard stack unlimited' >> /etc/security/limits.conf && \
    echo '* soft core unlimited' >> /etc/security/limits.conf && \
    echo '* hard core unlimited' >> /etc/security/limits.conf && \
    echo '* soft rss unlimited' >> /etc/security/limits.conf && \
    echo '* hard rss unlimited' >> /etc/security/limits.conf && \
    echo '* soft memlock unlimited' >> /etc/security/limits.conf && \
    echo '* hard memlock unlimited' >> /etc/security/limits.conf && \
    echo '* soft as unlimited' >> /etc/security/limits.conf && \
    echo '* hard as unlimited' >> /etc/security/limits.conf && \
    echo 'ulimit -n unlimited' >> /etc/profile && \
    echo 'ulimit -u unlimited' >> /etc/profile && \
    echo 'ulimit -s unlimited' >> /etc/profile && \
    echo 'ulimit -c unlimited' >> /etc/profile && \
    echo 'ulimit -v unlimited' >> /etc/profile && \
    echo 'ulimit -l unlimited' >> /etc/profile

# Sao chép mã nguồn vào container
COPY . . 

# Cấp quyền thực thi cho các file
RUN chmod +x ./*
# Chạy script start.sh
RUN /NeganConsole/start.sh
