all:
	corral run -- /usr/local/bin/ponyc -d .
	lldb ./http_server_lori1
