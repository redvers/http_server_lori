all:
	corral run -- ponyc -d .
	./http_server_lori1
