class_name EZUnpacker
extends RefCounted

var _pba : PackedByteArray
var cursor := 0

const S32 := 4
const S64 := 8
const HALF := 2
const FLOAT := 4
const BOOL := 1

static func create(pba: PackedByteArray) -> EZUnpacker:
    var ez := EZUnpacker.new()
    ez._pba = pba
    
    return ez

func vec3() -> Vector3:
    var x := self.float()
    var y := self.float()
    var z := self.float()
    
    return Vector3(x, y, z)

func vec2() -> Vector2:
    var x := self.float()
    var y := self.float()
    
    return Vector2(x, y)

func float() -> float:
    var v := _pba.decode_half(cursor)
    cursor += HALF
    return v
    
func s32() -> int:
    var v := _pba.decode_s32(cursor)
    cursor += S32
    return v
    
func s64() -> int:
    var v := _pba.decode_s64(cursor)
    cursor += S64
    return v
    
func boolean() -> bool:
    var v := _pba.decode_u8(cursor)
    cursor += BOOL
    return v
    
func string() -> String:
    var str_size := s32()
    var v := _pba.slice(cursor, cursor + str_size)
    cursor += str_size
    return v.get_string_from_utf8()
    
func get_array() -> PackedByteArray:
    return _pba
