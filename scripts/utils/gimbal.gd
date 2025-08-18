class_name Gimbal
extends RefCounted

@export var highest_angle := 88.0
@export var lowest_angle := -88.0
@export var starting_angle := -40.0
@export var responsiveness := 45.0

var outer_gimbal := Quaternion.IDENTITY
var inner_gimbal := Quaternion.IDENTITY

var quaternion := Quaternion.IDENTITY

var _outer_gimbal_target := Quaternion.IDENTITY
var _inner_gimbal_target := Quaternion.IDENTITY

func _init() -> void:
    rotate_inner_gimbal(deg_to_rad(starting_angle))

func rotate_outer_gimbal(angle: float) -> void:
    _outer_gimbal_target *= Quaternion(Vector3.UP, angle)
    
func rotate_inner_gimbal(angle: float) -> void:
    _inner_gimbal_target *= Quaternion(Vector3.RIGHT, angle)
    
    var rot := _inner_gimbal_target.get_euler()
    rot.x = clampf(
        rot.x,
        deg_to_rad(lowest_angle),
        deg_to_rad(highest_angle)
    )
    
    _inner_gimbal_target = Quaternion.from_euler(rot)

func tick(delta: float) -> void:
    outer_gimbal = outer_gimbal.slerp(_outer_gimbal_target, Lerp.blend(responsiveness, delta))
    inner_gimbal = inner_gimbal.slerp(_inner_gimbal_target, Lerp.blend(responsiveness, delta))
    
    quaternion = outer_gimbal * inner_gimbal

func get_pitch() -> float:
    return inner_gimbal.get_euler().x
    
func get_yaw() -> float:
    return outer_gimbal.get_euler().y

static func from_rotation(rotation: Vector3) -> Gimbal:
    var gimbal := Gimbal.new()
    
    gimbal.outer_gimbal = Quaternion.from_euler(Vector3(0.0, rotation.y, 0.0))
    gimbal._outer_gimbal_target = gimbal.outer_gimbal
    
    gimbal.inner_gimbal = Quaternion.from_euler(Vector3(rotation.x, 0.0, 0.0))
    gimbal._inner_gimbal_target = gimbal.inner_gimbal
    
    gimbal.quaternion = Quaternion.from_euler(rotation)
    
    return gimbal
