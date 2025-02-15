primitive Http200
  fun apply(allowed: String val = "GET"): String val =>
"HTTP/1.1 200 OK\r\nContent-length: 9\r\nConnection: close\r\n\r\nI'm found"
