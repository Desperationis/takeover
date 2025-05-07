import sys
import termios
import tty
import select

def getch_nonblocking():
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        # Poll stdin: timeout=0 for non-blocking
        if select.select([sys.stdin], [], [], 0)[0]:
            return sys.stdin.read(1)
        else:
            return None
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)

# Example usage:
while True:
    ch = getch_nonblocking()
    if ch:
        print(f'Pressed: {ch!r}')
        if ch == 'q':
            break
