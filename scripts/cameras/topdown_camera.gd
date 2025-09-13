class_name TopdownCamera
extends Camera3D

@export var highest_angle := 88.0
@export var lowest_angle := -88.0
@export var starting_angle := Vector2(-50.0, 0.0)

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

var cursor_world_position := Vector3.ZERO

var result := {}

var _picked := Node3D.new()

func pick(collision_mask = 0xFFFFFFFF, distance: float = 50.0) -> Dictionary:
    var screen_position := get_viewport().get_mouse_position()
    var camera := get_viewport().get_camera_3d()
    
    var from := camera.project_ray_origin(screen_position)
    var to := camera.project_ray_origin(screen_position) + camera.project_ray_normal(screen_position) * distance
    var query := PhysicsRayQueryParameters3D.create(from, to, collision_mask)
    var _result := camera.get_world_3d().direct_space_state.intersect_ray(query)
    
    if _result != {}:
        cursor_world_position = _result["position"]
        
        var collider : Node3D = _result["collider"]
        if _picked != collider:
            if collider.has_method("focus"):
                collider.focus()
                
            if _picked and _picked.has_method("blur"):
                _picked.blur()
        
            _picked = collider
    
    result = _result
    return result

func shape_pick(distance: float = 50.0) -> Array[Dictionary]:
    var result := pick(distance)
    if result == {}:
        return []
        
    var position : Vector3 = result["position"]
    
    var shape_query := PhysicsShapeQueryParameters3D.new()
    shape_query.shape = SphereShape3D.new()
    shape_query.shape.radius = 0.25
    
    shape_query.transform = Transform3D().translated(position)
    
    return get_world_3d().direct_space_state.intersect_shape(shape_query)

func _ready() -> void:
    top_level = true
    
    outer = outer.rotated_local(Vector3.UP, deg_to_rad(starting_angle.y))
    outer = outer.translated(target.global_position)
    inner = inner.rotated_local(Vector3.RIGHT, deg_to_rad(starting_angle.x))

func rotate_yaw(angle: float) -> void:
    outer = outer.rotated_local(Vector3.UP, angle)
    
func rotate_pitch(angle: float) -> void:
    inner = inner.rotated_local(Vector3.RIGHT, angle)

func zoom(amount: float) -> void:
    distance += amount

func _physics_process(delta: float) -> void:
    _lerp_to_target(delta)
    _process_camera_collision()
    
    pick()

func _lerp_to_target(delta: float) -> void:
    outer.origin = outer.origin.lerp(target.global_position, Lerp.blend(follow_power, delta))
    
func _process_camera_collision() -> void:
    var _t := (outer * inner)
    var _ct := _t.translated_local(Vector3(0.0, 0.0, distance))
    
    var query := PhysicsRayQueryParameters3D.new()
    query.from = _t.origin
    query.to = _ct.origin
    
    var result := get_world_3d().direct_space_state.intersect_ray(query)
    
    if result != {}:
        position = result["position"]
    else:
        position = _ct.origin
        
    basis = _ct.basis
