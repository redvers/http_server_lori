use "runtime_info"
use "lori"
use "http_server_lori"

actor Main
  new create(env: Env) =>
    let server: HTTPServer = HTTPServer(TCPListenAuth(env.root),
                                        SchedulerStatsAuth(env.root),
                                        "",
                                        "50000")
