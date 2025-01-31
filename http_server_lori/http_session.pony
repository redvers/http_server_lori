use "../../lori/lori"
use "debug"
use "buffered"

primitive _ExpectRequestLine
primitive _ExpectHeaders
primitive _ExpectBody
primitive _ExpectChunkStart
primitive _ExpectChunk
primitive _ExpectChunkEnd

type HTTPSessionStatus is (
  _ExpectRequestLine |
      _ExpectHeaders |
      _ExpectBody    |
      _ExpectChunkStart |
      _ExpectChunk   |
      _ExpectChunkEnd)

trait HTTPSessionActor is TCPServerActor
  fun ref _connection(): TCPConnection
  fun ref _http_session_status(): HTTPSessionStatus

  fun ref _on_received(data: Array[U8] iso): None =>
    Debug.out("trait: HTTPSessionActor._on_received() has been called")
  fun ref _on_closed() => None
    Debug.out("trait: HTTPSessionActor._on_closed() has been called")
  fun ref _on_throttled() => None
    Debug.out("trait: HTTPSessionActor._on_throttled() has been called")
  fun ref _on_unthrottled() => None
    Debug.out("trait: HTTPSessionActor._on_unthrottled() has been called")






actor HTTPSession is HTTPSessionActor
  var _tcp_connection: TCPConnection = TCPConnection.none()
  var _session_status: HTTPSessionStatus = _ExpectRequestLine
  let buffer: Reader = Reader
  let httprequest: HTTPRequest = HTTPRequest

  fun ref _connection(): TCPConnection => _tcp_connection

  new create(auth: TCPServerAuth, fd: U32) =>
    Debug.out("HTTPSession.create() has been called")
    _tcp_connection = TCPConnection.server(auth, fd, this)

  fun ref _on_received(data: Array[U8] iso) =>
    Debug.out("HTTPSession._on_received() has been called")
    buffer.append(consume data)
    match _session_status
    | _ExpectRequestLine => parse_request_line()
                            Debug.out(httprequest.string())
    end

  fun ref parse_request_line() =>
    // FIXME - NOTE - We may need to split up this section more
    // since failure to complete this entire function will result
    // in a desynched session.
    httprequest.method =
      try
        Debug.out("HTTPSession.parse_request_line(METHOD)")
        match String.from_array(buffer.read_until(' ')?)
        | "GET" => HTTPGet
        | "POST" => HTTPPost
        | "CONNECT" => HTTPConnect
        | "OPTIONS" => HTTPOptions
        | "PUT" => HTTPPut
        | "HEAD" => HTTPHead
        | "DELETE" => HTTPDelete
        | "PATCH" => HTTPPatch
        | "TRACE" => HTTPTrace
        end
      else
        Debug.out("HTTPSession.parse_request_line(METHOD) needs more bytes")
        return None
      end

    httprequest.path =
      try
        Debug.out("HTTPSession.parse_request_line(PATH)")
        String.from_array(buffer.read_until(' ')?)
      else
        Debug.out("HTTPSession.parse_request_line(PATH) needs more bytes")
        return None
      end

    httprequest.version =
      try
        Debug.out("HTTPSession.parse_request_line(VERSION)")
        buffer.line()?
      else
        Debug.out("HTTPSession.parse_request_line(VERSION) needs more bytes")
        return None
      end






  fun ref _http_session_status(): HTTPSessionStatus => _session_status

type HTTPMethod is (
  HTTPGet |
  HTTPPost |
  HTTPConnect |
  HTTPOptions |
  HTTPPut |
  HTTPHead |
  HTTPDelete |
  HTTPPatch |
  HTTPTrace |
  None)

class HTTPRequest
  var method: HTTPMethod = None
  var path: String val = ""
  var version: String val = ""

  fun ref string(): String val =>
    method.string() + "|" + path + "|" + version + "|"

primitive HTTPGet
  fun string(): String val => "HTTPGet"
primitive HTTPPost
  fun string(): String val => "HTTPPost"
primitive HTTPConnect
  fun string(): String val => "HTTPConnect"
primitive HTTPOptions
  fun string(): String val => "HTTPOptions"
primitive HTTPPut
  fun string(): String val => "HTTPPut"
primitive HTTPHead
  fun string(): String val => "HTTPHead"
primitive HTTPDelete
  fun string(): String val => "HTTPDelete"
primitive HTTPPatch
  fun string(): String val => "HTTPPatch"
primitive HTTPTrace
  fun string(): String val => "HTTPTrace"
