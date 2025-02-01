use "../../lori/lori"
use "debug"
use "collections"

trait HTTPSessionActor is TCPServerActor
  fun ref _connection(): TCPConnection
  fun ref _http_session_status(): HTTPSessionStatus

  fun ref _on_received(data: Array[U8] iso): None =>
    Debug.out("trait: HTTPSessionActor._on_received() has been called")
  fun ref _on_closed() => None
    Debug.out("trait: HTTPSessionActor._on_closed() has been called")
  fun ref _on_throttled() => None
    Debug.out("trait: HTTPSessionActor._on_throttled() has been called")
  fun ref _on_unthrottled() => None
    Debug.out("trait: HTTPSessionActor._on_unthrottled() has been called")
