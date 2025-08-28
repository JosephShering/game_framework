class_name TopdownCamera
extends Camera3D

@export var highest_angle := 88.0
@export var lowest_angle := -88.0
@export var starting_angle := 0.0

@export var target : Node

@export var follow_power := 30.0
@export var arm_follow_power := 30.0
@export var distance := 10.0:
    set(nd):
        distance = nd

@export_group("Zoom")
@export var max_zoom := 15.0
@export var min_zoom := 6.0

var outer := Transform3D.IDENTITY
var inner := Transform3D.IDENTITY
var offset := Transform3D()

var spring_arm := SpringArm3D.new()
var target_point := Node3D.new()

func _ready() -> void:
    top_level = true
    
    outer = outer.rotated_local(Vector3.UP, deg_to_rad(0.0))
    outer = outer.translated(target.global_position)
    
    inner = inner.rotated_local(Vector3.RIGHT, deg_to_rad(starting_angle))
    
    if get_parent().is_multiplayer_authority():
        current = true
    else:
        current = false

func rotate_yaw(angle: float) -> void:
    outer = outer.rotated_local(Vector3.UP, angle)
    
func rotate_pitch(angle: float) -> void:
    inner = inner.rotated_local(Vector3.RIGHT, angle)

func _physics_process(delta: float) -> void:
    outer.origin = target.global_position
    
    var _t := (outer * inner)
    var _ct := _t.translated_local(Vector3(0.0, 0.0, distance))
    
    var query := PhysicsRayQueryParameters3D.new()
    query.from = _t.origin
    query.to = _ct.origin
    
    var result := get_world_3d().direct_space_state.intersect_ray(query)
    
    if result != {}:
        position = result["position"]
    
    transform = _ct
    
