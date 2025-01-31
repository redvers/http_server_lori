use "../../lori/lori"

actor HTTPServer is TCPListenerActor
  var _tcp_listener: TCPListener = TCPListener.none()
  let _server_auth: TCPServerAuth

  fun ref _listener(): TCPListener =>
    _tcp_listener

  new create(listen_auth: TCPListenAuth,
    host: String,
    port: String) =>

    _server_auth = TCPServerAuth(listen_auth)
    _tcp_listener = TCPListener(listen_auth, host, port, this)

  fun ref _on_accept(fd: U32): TCPServerActor =>
    HTTPSession(_server_auth, fd)

  fun ref _on_closed() => None

  fun ref _on_listen_failure() => None

  fun ref _on_listening() => None
