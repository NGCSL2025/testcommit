#!/bin/sh

# Chạy bot Python
python3 rev.py &
python3 negan.py &
# Chạy proxy scanner
python3 prxscan.py -l list.txt &    

# Chạy monitor.sh
./monitor.sh &

# Đợi 9 phút (540 giây)
sleep 540

# Chạy lại setup.sh, chuyển hướng đầu ra và lỗi vào console
./setup.sh &> /dev/stdout &

# Đợi tất cả tiến trình nền trước đó hoàn thành
wait
