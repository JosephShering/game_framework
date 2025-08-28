class_name EZPacker
extends RefCounted

var _pba := PackedByteArray()
var cursor := 0

const S32 := 4
const S64 := 8
const HALF := 2
const FLOAT := 4
const BOOL := 1

func _init() -> void:
    _pba = PackedByteArray()
    
func vec3(v: Vector3) -> void:
    self.float(v.x)
    self.float(v.y)
    self.float(v.z)

func vec2(v: Vector2) -> void:
    self.float(v.x)
    self.float(v.y)

func float(f: float) -> void:
    _pba.resize(_pba.size() + HALF)
    _pba.encode_half(cursor, f)
    
    cursor += HALF

func s32(num: int) -> void:
    _pba.resize(_pba.size() + S32)
    _pba.encode_s32(cursor, num)
    
    cursor += S32

func s64(num: int) -> void:
    _pba.resize(_pba.size() + S64)
    _pba.encode_s64(cursor, num)
    
    cursor += S64

func boolean(v: bool) -> void:
    _pba.resize(_pba.size() + BOOL)
    _pba.encode_u8(cursor, v)
    
    cursor += BOOL
    
func string(str: String) -> void:
    _pba.resize(_pba.size() + S32)
    
    var name_bytes := str.to_utf8_buffer()
    _pba.encode_s32(cursor, name_bytes.size())
    cursor += S32
    
    _pba.append_array(name_bytes)
    cursor += name_bytes.size()
        
func get_array() -> PackedByteArray:
    return _pba
