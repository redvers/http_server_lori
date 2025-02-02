use "collections"

class HTTPRequest
  var method: HTTPMethod = None
  var path: String val = ""
  var version: HTTPVersion = None
  var headers: Map[String val, String val] iso = recover iso Map[String val, String val] end
  var incoming_length: USize = 0

  fun ref string(): String val =>
    method.string() + "|" + path + "|" + version.string() + "|"



primitive HTTP10 fun string(): String val => "HTTP10"
primitive HTTP11 fun string(): String val => "HTTP11"

type HTTPVersion is (HTTP10 | HTTP11 | None)
