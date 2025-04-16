# Sử dụng Alpine làm base image
FROM alpine:latest

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt gói hệ thống cần thiết từ mirror TQ
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
    bash procps coreutils bc ncurses iproute2 sysstat \
    util-linux pciutils curl jq nodejs npm py3-pip python3-dev libffi-dev build-base && \
    rm -rf /var/cache/apk/*

# Cài Node.js packages
RUN npm install --omit=dev colors randomstring user-agents hpack axios https commander socks node-telegram-bot-api --silent && \
    rm -rf /root/.npm

# Cài Python packages
RUN pip3 install --no-cache-dir --break-system-packages requests python-telegram-bot pytz

# Tăng toàn bộ giới hạn `ulimit` lên `unlimited`
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

# Copy source
COPY . .

# Cấp quyền thực thi cho các file
RUN chmod +x ./*

# Chạy script start.sh
RUN /NeganConsole/start.sh
