use "../../lori/lori"
use "debug"
use "buffered"
use "collections"

actor HTTPSession is HTTPSessionActor
  var _tcp_connection: TCPConnection = TCPConnection.none()
  var _session_status: HTTPSessionStatus = _ExpectRequestLine
  let buffer: Reader = Reader
  let httprequest: HTTPRequest = HTTPRequest

  fun ref _connection(): TCPConnection => _tcp_connection

  new create(auth: TCPServerAuth, fd: U32) =>
    Debug.out("HTTPSession.create() has been called")
    _tcp_connection = TCPConnection.server(auth, fd, this)

  fun ref mystatus(): HTTPSessionStatus => _session_status
  fun ref setstatus(status: HTTPSessionStatus) => _session_status = status
  fun ref mybuffer(): Reader => buffer
  fun ref myhttprequest(): HTTPRequest => httprequest

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




  fun ref _http_session_status(): HTTPSessionStatus => _session_status

