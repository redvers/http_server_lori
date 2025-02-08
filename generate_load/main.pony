use "net"

class MyTCPConnectionNotify is TCPConnectionNotify
  let _out: OutStream
  let _main: Main tag

  new create(main: Main tag, out: OutStream) =>
    _out = out
    _main = main

  fun ref connected(conn: TCPConnection ref) =>
    conn.write("GET /wibble HTTP/1,1\r\nHost: 127.0.0.1:50000\r\n\r\n")

  fun ref received(
    conn: TCPConnection ref,
    data: Array[U8] iso,
    times: USize)
    : Bool
  =>
    _out.write(".")
    conn.close()
    _main.ship_it(_main)
    true

  fun ref connect_failed(conn: TCPConnection ref) =>
    None

actor Main
  let env: Env
  new create(env': Env) =>
    env = env'
    ship_it(this)

  be ship_it(m: Main tag) =>
    TCPConnection(TCPConnectAuth(env.root),
      recover MyTCPConnectionNotify(this, env.out) end, "", "50000")
