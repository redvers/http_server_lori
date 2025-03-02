all:
	corral run -- ponyc .
	lldb ./http_server_lori1
