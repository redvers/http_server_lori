all:
	corral run -- /usr/local/bin/ponyc .
	lldb ./http_server_lori1
