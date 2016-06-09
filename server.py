#!/usr/bin/env python2

import BaseHTTPServer
import ssl

class Handler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_GET(s):
        s.send_response(200)
        s.send_header("Content-type", "text/html")
        s.end_headers()
        s.wfile.write("OK")

httpd = BaseHTTPServer.HTTPServer(('localhost', 4000), Handler)
httpd.socket = ssl.wrap_socket (httpd.socket, certfile='./server.pem', server_side=True)
httpd.serve_forever()
