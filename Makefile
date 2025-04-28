all:
	corral run -- ponyc . -Dopenssl_3.0.x
	./http_server_lori1
