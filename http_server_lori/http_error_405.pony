primitive HttpError405
  fun apply(allowed: String val = "GET"): String val =>
"HTTP/1.1 405 Method Not Allowed\r
Content-length: 0\r
Connection: close\r\n"

