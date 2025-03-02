use "debug"
use "runtime_info"
use "lori"

actor HTTPServer is TCPListenerActor
  var _tcp_listener: TCPListener = TCPListener.none()
  var cnt: U64 = 0
  let _server_auth: TCPServerAuth
  let ssa: SchedulerStatsAuth

  fun ref _listener(): TCPListener =>
    _tcp_listener

  new create(listen_auth: TCPListenAuth, ssa': SchedulerStatsAuth,
    host: String,
    port: String) =>

    ssa = ssa'
    _server_auth = TCPServerAuth(listen_auth)
    _tcp_listener = TCPListener(listen_auth, host, port, this)

  fun ref _on_accept(fd: U32): HTTPSessionActor tag =>
    cnt = cnt + 1
    if ((cnt %% 10000) == 0) then
      @printf("Count: %d\n".cstring(), cnt)
    end
    HTTPSession(_server_auth, fd)

  fun ref _on_closed() => None

  fun ref _on_listen_failure() => None

  fun ref _on_listening() => None
