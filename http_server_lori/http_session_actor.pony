use "lori"
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
    match status()
    | _ExpectRequestLine => parse_request_line()
    | _ExpectHeaders     => parse_headers()
    | _ExpectBody        => return
    end

  fun ref parse_request_line() =>
    try
      var line: String iso = buffer().line()?
    else
      P("AAAAAAAARRRRRRRHHHHHH\n".cstring())
    end
    request().method = HTTPGet
    request().path = "/fake"
    request().version = HTTP11
    /*
      try
        P("a".cstring())
        match String.from_array(buffer().read_until(' ')?)
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
        P("b".cstring())
      else
        return None
      end

    request().path =
      try
        P("c".cstring())
        let q = String.from_array(buffer().read_until(' ')?)
        P("d".cstring())
        consume q
      else
        return None
      end

    request().version =
      try
        P("e".cstring())
        match buffer().line()?
        | "HTTP/1.0" => HTTP10
        | "HTTP/1.1" => HTTP11
        | let x: String val => None
        end
        P("f".cstring())
      else
        return None
      end
*/
    setstatus(_ExpectHeaders)
    process_buffer()

  fun ref parse_headers() =>
    while true do
      try
        let h: String val = buffer().line()?
        if (h == "") then
          break
        else
          let offs: ISize = h.find(": ")?
          let k: String val = h.substring(0, offs)
          let v: String val = h.substring(offs+2)
          request().headers.insert(k,v)
        end
      else
        None
      end
    end

    match request().method
//    | HTTPGet => setstatus(_SendYourData)
    | HTTPHead => setstatus(_SendYourData)
    else
      setstatus(_ExpectBody)
      _connection().send(Http200())
      _connection().close()
    end




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
