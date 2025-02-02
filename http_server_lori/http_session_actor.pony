use "../../lori/lori"
use "debug"
use "buffered"
use "collections"

trait HTTPSessionActor is TCPServerActor
  fun ref mybuffer(): Reader
  fun ref mystatus(): HTTPSessionStatus
  fun ref setstatus(status: HTTPSessionStatus): None
  fun ref myhttprequest(): HTTPRequest

  fun ref process_buffer() =>
    match mystatus()
    | _ExpectRequestLine => parse_request_line()
    | _ExpectHeaders     => parse_headers()
    end

  fun ref parse_request_line() =>
    // FIXME - NOTE - We may need to split up this section more
    // since failure to complete this entire function will result
    // in a desynched session.
    //
    // Yeah - I really should just be pulling a line()
    //
    myhttprequest().method =
      try
        Debug.out("HTTPSessionActor.parse_request_line(METHOD)")
        match String.from_array(mybuffer().read_until(' ')?)
        | "GET" => HTTPGet
        | "HEAD" => HTTPHead
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
        Debug.out("HTTPSessionActor.parse_request_line(METHOD) needs more bytes")
        return None
      end

    myhttprequest().path =
      try
        Debug.out("HTTPSessionActor.parse_request_line(PATH)")
        String.from_array(mybuffer().read_until(' ')?)
      else
        Debug.out("HTTPSessionActor.parse_request_line(PATH) needs more bytes")
        return None
      end

    myhttprequest().version =
      try
        Debug.out("HTTPSessionActor.parse_request_line(VERSION)")
        match mybuffer().line()?
        | "HTTP/1.0" => HTTP10
        | "HTTP/1.1" => HTTP11
        | let x: String val => Debug.out(x)
        end
      else
        Debug.out("HTTPSessionActor.parse_request_line(VERSION) needs more bytes")
        return None
      end

    Debug.out("HTTPSessionActor.parse_request_line() updated to _ExpectHeaders")
    Debug.out(myhttprequest().string())
    setstatus(_ExpectHeaders)
    process_buffer()

  fun ref parse_headers() =>
    Debug.out("HTTPSessionActor._parse_headers() has been called")
    while true do
      try
        let h: String val = mybuffer().line()?
        if (h == "") then
          Debug.out("Final Header Received")
          break
        else
          let offs: ISize = h.find(": ")?
          let k: String val = h.substring(0, offs)
          let v: String val = h.substring(offs+2)
          myhttprequest().headers.insert(k,v)
          Debug.out("Header|"+k+"|"+v)
        end
      else
        Debug.out("HTTPSessionActor._parse_headers() need more data")
      end
    end
    Debug.out("HTTPSessionActor._parse_headers() sets _ExpectBody")
    setstatus(_ExpectBody)






  fun ref _connection(): TCPConnection
  fun ref _http_session_status(): HTTPSessionStatus

  fun ref _on_received(data: Array[U8] iso): None =>
    Debug.out("trait: HTTPSessionActor._on_received() has been called")
    mybuffer().append(consume data)
    process_buffer()

  fun ref _on_closed() => None
    Debug.out("trait: HTTPSessionActor._on_closed() has been called")
  fun ref _on_throttled() => None
    Debug.out("trait: HTTPSessionActor._on_throttled() has been called")
  fun ref _on_unthrottled() => None
    Debug.out("trait: HTTPSessionActor._on_unthrottled() has been called")
