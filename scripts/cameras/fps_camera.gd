class_name FPSCamera
extends BasePlayerCamera

signal hovered(result: Dictionary, label_text: String)
signal unhovered()

@export_flags_3d_physics var ray_collision_mask : int
@export var ray_length : float = 1.0

var query : PhysicsRayQueryParameters3D

var _collider_id := 0
var _collider = null

func _ready() -> void:
    query = PhysicsRayQueryParameters3D.new()
    query.collide_with_bodies = true
    query.collide_with_areas = true
    query.collision_mask = ray_collision_mask
    query.hit_from_inside = false
    query.hit_back_faces = false
    
    if target.has_method("get_rid"):
        query.exclude = [
            target.get_rid()
        ]
    
func _physics_process(delta: float) -> void:
    query.from = global_position
    query.to = global_position + (-global_basis.z * ray_length)
    
    var result = get_world_3d().direct_space_state.intersect_ray(query)
    
    if result != {} and result["collider"].has_method("hover"):
        if _collider_id != result["collider_id"]:
            if _collider_id > 0:
                unhovered.emit()
            
            _collider = result["collider"]
            var label_text : String = _collider.hover()
            
            hovered.emit(result, label_text)
            
        _collider_id = result["collider_id"]
    else:
        if _collider_id != 0:
            if _collider:
                _collider.unhover()
            
            unhovered.emit()
            _collider_id = 0
