use "lori"
use "buffered"
use "collections"

actor HTTPSession is HTTPSessionActor
  var _tcp_connection: TCPConnection = TCPConnection.none()
  var _status: HTTPSessionStatus = _ExpectRequestLine
  let _buffer: Reader = Reader
  let _request: HTTPRequest = HTTPRequest

  fun ref _connection(): TCPConnection => _tcp_connection
  fun ref _connection_kill() =>
    _tcp_connection = TCPConnection.none()

  new create(auth: TCPServerAuth, fd: U32) =>
    _tcp_connection = TCPConnection.server(auth, fd, this)

  fun ref status(): HTTPSessionStatus => _status
  fun ref setstatus(status': HTTPSessionStatus) => _status = status'
  fun ref buffer(): Reader => _buffer
  fun ref request(): HTTPRequest => _request

/*
   +-------------------+-----------------+
   | Header Field Name | Defined in...   |
   +-------------------+-----------------+
   | Content-Type      | Section 3.1.1.5 |
   | Content-Encoding  | Section 3.1.2.2 |
   | Content-Language  | Section 3.1.3.2 |
   | Content-Location  | Section 3.1.4.2 |
   +-------------------+-----------------+
                                           */

