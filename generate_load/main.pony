use "net"

class MyTCPConnectionNotify is TCPConnectionNotify
  let _out: OutStream
  let _main: Main tag
  let _cnt: USize

  new create(cnt: USize, main: Main tag, out: OutStream) =>
    _out = out
    _main = main
    _cnt = cnt

  fun ref connected(conn: TCPConnection ref) =>
    conn.write("GET /" + _cnt.string() + " HTTP/1.1\r\nHost: 127.0.0.1:50000\r\n\r\n")
    _out.print(">"+_cnt.string())

  fun ref received(
    conn: TCPConnection ref,
    data: Array[U8] iso,
    times: USize)
    : Bool
  =>
    _out.print("<"+_cnt.string())
//    conn.close()
    _main.ship_it(_main)
    false

  fun ref connect_failed(conn: TCPConnection ref) =>
    None

actor Main
  let env: Env
  var _cnt: USize = 0

  new create(env': Env) =>
    env = env'
    ship_it(this)

  be ship_it(m: Main tag) =>
    _cnt = _cnt + 1
    TCPConnection(TCPConnectAuth(env.root),
      recover MyTCPConnectionNotify(_cnt, this, env.out) end, "192.168.12.129", "50000")
