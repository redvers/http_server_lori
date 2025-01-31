use "../lori/lori"
use "http_server_lori"

actor Main
  new create(env: Env) =>
    let server: HTTPServer = HTTPServer(TCPListenAuth(env.root),
                                        "",
                                        "50000")
