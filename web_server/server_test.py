import socket
from http.server import HTTPServer, BaseHTTPRequestHandler, SimpleHTTPRequestHandler

import asyncio
import websockets
import _thread

# get ip
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.connect(("8.8.8.8", 80))
ip = s.getsockname()[0]
print(ip)
s.close()

# print(socket.gethostbyname(socket.gethostname()))

# class TestServer(SimpleHTTPRequestHandler):
#     def __init__(self, *args, directory=None, **kwargs):
#         self.path = "/mnt/host/repos/zk-test/web_server/"
#         super().__init__(*args, **kwargs)

#     # def do_GET(self):
#     #     print("there is a get msg")

#     def do_POST(self):
#         print("there is a post msg")

async def echo(websocket):
    async for message in websocket:
        print("receive " + message)
        await websocket.send(message)

async def ws_main():
    async with  websockets.serve(echo, ip, 8765):
        await asyncio.Future()

def ws_thread(threadName, arg):
    print(threadName + "to start ws on 8765")
    asyncio.run(ws_main())
    print(threadName + "to end ws on 8765")

_thread.start_new_thread( ws_thread, ("ws_main", 1, ) )

host = ('',8001)
server = HTTPServer(host, SimpleHTTPRequestHandler)
print("Starting server, listen at: %s:%s" % host)
server.serve_forever()