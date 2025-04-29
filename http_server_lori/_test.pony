use "buffered"
use "runtime_info"
use "pony_test"
use "lori"

use http = "http"

actor \nodoc\ Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) => None
    test(_TestOptions)



class \nodoc\ iso _TestOptions is UnitTest
  fun name(): String val => "_TestOptions"

  fun apply(h: TestHelper) =>
    let server: _HTTPServerListenerOptions = _HTTPServerListenerOptions(TCPListenAuth(h.env.root),
                                        "",
                                        "50000")
//    h.dispose_when_done(server)
    h.long_test(500000000000)
    h.assert_true(true)


actor \nodoc\ _HTTPServerListenerOptions is TCPListenerActor
  var _tcp_listener: TCPListener = TCPListener.none()
  var cnt: U64 = 0
  let _server_auth: TCPServerAuth

  fun ref _listener(): TCPListener =>
    _tcp_listener

  new create(listen_auth: TCPListenAuth,
    host: String,
    port: String) =>

    _server_auth = TCPServerAuth(listen_auth)
    _tcp_listener = TCPListener(listen_auth, host, port, this, 100)

  fun ref _on_accept(fd: U32): HTTPSessionActor tag =>
    cnt = cnt + 1
    if ((cnt %% 10000) == 0) then
      @printf("Count: %d\n".cstring(), cnt)
    end
    _HTTPSessionOptions(_server_auth, fd)

  fun ref _on_closed() => None

  fun ref _on_listen_failure() => None

  fun ref _on_listening() => None

actor _HTTPSessionOptions is HTTPSessionActor
  var _tcp_connection: TCPConnection = TCPConnection.none()
  var _status: HTTPSessionStatus = _ExpectRequestLine
  let _buffer: Reader = Reader
  let _request: HTTPRequest = HTTPRequest

  fun ref _connection(): TCPConnection => _tcp_connection
  fun ref _connection_kill() =>
    _tcp_connection = TCPConnection.none()

  new create(auth: TCPServerAuth, fd: U32) =>
    _tcp_connection = TCPConnection.server(auth, fd, this, this)

  fun ref status(): HTTPSessionStatus => _status
  fun ref setstatus(status': HTTPSessionStatus) => _status = status'
  fun ref buffer(): Reader => _buffer
  fun ref request(): HTTPRequest => _request


