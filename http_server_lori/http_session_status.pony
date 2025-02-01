
primitive _ExpectRequestLine
primitive _ExpectHeaders
primitive _ExpectBody
primitive _ExpectChunkStart
primitive _ExpectChunk
primitive _ExpectChunkEnd

type HTTPSessionStatus is (
  _ExpectRequestLine |
      _ExpectHeaders |
      _ExpectBody    |
      _ExpectChunkStart |
      _ExpectChunk   |
      _ExpectChunkEnd)
