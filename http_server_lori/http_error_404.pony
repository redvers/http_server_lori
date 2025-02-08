primitive HttpError404
  fun apply(allowed: String val = "GET"): String val =>
"HTTP/1.1 404 Not found\r\nContent-length: 0\r\n\r\n"
