import socket
import time

ip = '0.0.0.0'
port = 9000

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((ip, port))
s.listen(1)
print(f"Listening on {port}")
conn, addr = s.accept()
print(f"Connection from {addr}")

time.sleep(0.5)
output = conn.recv(1024).decode()
while True:
    cmd = input()
    conn.send(cmd.encode() + b"\n")
    time.sleep(0.5)
    output = conn.recv(1024).decode()
    print(output, end="")

