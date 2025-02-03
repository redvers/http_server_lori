
primitive _ExpectRequestLine fun string(): String val => "_ExpectRequestLine"
primitive _ExpectHeaders fun string(): String val => "_ExpectHeaders"
primitive _ExpectBody fun string(): String val => "_ExpectBody"
primitive _ExpectChunkStart fun string(): String val => "_ExpectChunkStart"
primitive _ExpectChunk fun string(): String val => "_ExpectChunk"
primitive _ExpectChunkEnd fun string(): String val => "_ExpectChunkEnd"
primitive _SendYourData fun string(): String val => "_SendYourData"

type HTTPSessionStatus is (
      _ExpectRequestLine |
      _ExpectHeaders     |
      _ExpectBody        |
      _ExpectChunkStart  |
      _ExpectChunk       |
      _ExpectChunkEnd    |
      _SendYourData
)
