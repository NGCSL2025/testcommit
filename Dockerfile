FROM alpine

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói cần thiết
RUN apk add --no-cache \
    bash procps coreutils bc ncurses iproute2 sysstat \
    util-linux pciutils curl jq nodejs npm py3-pip

# Sao chép script vào container
COPY . .

# Cài đặt các package cho Node.js
RUN npm install colors randomstring user-agents

# Cài đặt các package cho Python
RUN pip3 install requests python-telegram-bot pytz

# Kiểm tra phiên bản Node.js, npm, pip và các package đã cài đặt
RUN node -v && npm -v && pip3 --version
