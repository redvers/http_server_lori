use "collections"

class HTTPRequest
  var method: HTTPMethod = None
  var path: String val = ""
  var version: String val = ""
  var headers: Map[String val, String val] iso = recover iso Map[String val, String val] end

  fun ref string(): String val =>
    method.string() + "|" + path + "|" + version + "|"

