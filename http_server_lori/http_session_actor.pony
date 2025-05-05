use "lori"
use "debug"
use "buffered"
use "collections"
use @pony_scheduler_index[I32]()

use @printf[I32](fmt: Pointer[U8] tag, ...)

trait HTTPSessionActor is (TCPConnectionActor & ServerLifecycleEventReceiver)
  fun ref status(): HTTPSessionStatus
  fun ref setstatus(status': HTTPSessionStatus): None
  fun ref request(): HTTPRequest
  fun ref buffer(): Reader

  fun ref process_buffer() =>
    """
    Handles incoming data.  Calls the appropriate function depending on where
    in the incoming HTTP Message we are: https://datatracker.ietf.org/doc/html/rfc9112#name-message-format

      HTTP-message = start-line CRLF
                   *( field-line CRLF )
                   CRLF
                   [ message-body ]
    """
    match status()
    | _ExpectRequestLine => parse_request_line()  // Expects start-line (transitions on CRLF)
    | _ExpectHeaders     => parse_headers()       // Expects *( field-line CRLF ) (transitions on additional CRLF)
    | _ExpectBody        => Debug.out(request().string())
      return                // Should be Content-Length length
    end

  fun ref parse_request_line() =>
    """
    RFC9112:
    In the interest of robustness, a server that is expecting to receive and parse a request-line SHOULD ignore at least one empty line (CRLF) received prior to the request-line. FIXME

    A request-line begins with a method token, followed by a single space (SP), the request-target, and another single space (SP), and ends with the protocol version.

  request-line   = method SP request-target SP HTTP-version
    """
    try
      var line: String val = buffer().line()?
      var s: Array[String val] = line.split_by(" ")

      request().method =
        match s(0)?
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
        else
          HTTPInvalid
        end

      request().version =
        match s(2)?
        | "HTTP/1.0" => HTTP10
        | "HTTP/1.1" => HTTP11
        else
          None
        end

      request().path = s(1)?

    else
      return // Line is incomplete apparently.
    end

    setstatus(_ExpectHeaders)
    process_buffer()

  fun ref parse_headers() =>
    while true do
      try
        let h: String val = buffer().line()?
        if (h == "") then
          Debug.out("Expecting Body")
          setstatus(_ExpectBody)
          break
        else
          let offs: ISize = h.find(": ")?
          let k: String val = h.substring(0, offs)
          let v: String val = h.substring(offs+2)
          request().headers.insert(k,v)
        end
      else
        Debug.out("Pending more")
        break
      end
    end
    Debug.out("Yay headers thus far!")

//    match request().method
//    | HTTPOptions => setstatus(_SendYourData)
//    | HTTPHead => setstatus(_SendYourData)
//    else
//      setstatus(_ExpectBody)
//      _connection().send(Http200())
//      _connection().close()
//    end




/*
 * These are the callbacks that used by TCPConnectionActor
 */

  fun ref _connection(): TCPConnection
  fun ref _connection_kill(): None
  fun ref _on_received(data: Array[U8] val): None =>
    buffer().append(consume data)
    process_buffer()
  fun ref _on_closed() => None
  fun ref _on_throttled() => None
  fun ref _on_unthrottled() => None
  fun ref _next_lifecycle_event_receiver(): None => None
