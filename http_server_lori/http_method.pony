type HTTPMethod is (
  HTTPGet |
  HTTPPost |
  HTTPConnect |
  HTTPOptions |
  HTTPPut |
  HTTPHead |
  HTTPDelete |
  HTTPPatch |
  HTTPTrace |
  None)

primitive HTTPGet
  fun string(): String val => "HTTPGet"
primitive HTTPPost
  fun string(): String val => "HTTPPost"
primitive HTTPConnect
  fun string(): String val => "HTTPConnect"
primitive HTTPOptions
  fun string(): String val => "HTTPOptions"
primitive HTTPPut
  fun string(): String val => "HTTPPut"
primitive HTTPHead
  fun string(): String val => "HTTPHead"
primitive HTTPDelete
  fun string(): String val => "HTTPDelete"
primitive HTTPPatch
  fun string(): String val => "HTTPPatch"
primitive HTTPTrace
  fun string(): String val => "HTTPTrace"
