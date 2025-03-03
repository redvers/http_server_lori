all:
	corral run -- ponyc . -Dopenssl_3.0.x
	lldb ./http_server_lori1
