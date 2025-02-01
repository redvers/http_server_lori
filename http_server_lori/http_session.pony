use "../../lori/lori"
use "debug"
use "buffered"
use "collections"

actor HTTPSession is HTTPSessionActor
  var _tcp_connection: TCPConnection = TCPConnection.none()
  var _session_status: HTTPSessionStatus = _ExpectRequestLine
  let buffer: Reader = Reader
  let httprequest: HTTPRequest iso = recover iso HTTPRequest end

  fun ref _connection(): TCPConnection => _tcp_connection

  new create(auth: TCPServerAuth, fd: U32) =>
    Debug.out("HTTPSession.create() has been called")
    _tcp_connection = TCPConnection.server(auth, fd, this)

  fun ref _on_received(data: Array[U8] iso) =>
    Debug.out("HTTPSession._on_received() has been called")
    buffer.append(consume data)
    process_buffer()

  fun ref process_buffer() =>
    match _session_status
    | _ExpectRequestLine => parse_request_line()
    | _ExpectHeaders     => parse_headers()
    end


  fun ref parse_headers() =>
    Debug.out("HTTPSession._parse_headers() has been called")
    while true do
      try
        let h: String val = buffer.line()?
        if (h == "") then
          Debug.out("Final Header Received")
          break
        else
          let offs: ISize = h.find(": ")?
          let k: String val = h.substring(0, offs)
          let v: String val = h.substring(offs+2)
          httprequest.headers.insert(k,v)
          Debug.out("Header|"+k+"|"+v)
        end
      else
        Debug.out("HTTPSession._parse_headers() need more data")
      end
    end
    Debug.out("HTTPSession._parse_headers() sets _ExpectBody")
    _session_status = _ExpectBody



  fun ref parse_request_line() =>
    // FIXME - NOTE - We may need to split up this section more
    // since failure to complete this entire function will result
    // in a desynched session.
    //
    // Yeah - I really should just be pulling a line()
    //
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

    Debug.out("HTTPSession.parse_request_line() updated to _ExpectHeaders")
    Debug.out(httprequest.string())
    _session_status = _ExpectHeaders
    process_buffer()






  fun ref _http_session_status(): HTTPSessionStatus => _session_status

