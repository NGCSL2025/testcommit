FROM alpine

# Tạo thư mục làm việc
WORKDIR /NeganConsole

# Cài đặt các gói cần thiết
RUN apk add --no-cache \
    bash procps coreutils bc ncurses iproute2 sysstat \
    util-linux pciutils curl jq dos2unix

# Sao chép script vào container
COPY monitor.sh /NeganConsole/monitor.sh

# Chuyển đổi script sang UNIX format và cấp quyền thực thi
RUN dos2unix /NeganConsole/monitor.sh && chmod +x /NeganConsole/monitor.sh

# Chạy script trong quá trình build
RUN /NeganConsole/monitor.sh
