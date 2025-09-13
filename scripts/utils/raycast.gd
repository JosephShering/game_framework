class_name Raycast
extends RefCounted

static func pick(
    viewport : Viewport,
    collision_mask = 0xFFFFFFFF,
    distance: float = 50.0
) -> Dictionary:
    var screen_position := viewport.get_mouse_position()
    var camera := viewport.get_camera_3d()
    
    var from := camera.project_ray_origin(screen_position)
    var to := camera.project_ray_origin(screen_position) + camera.project_ray_normal(screen_position) * distance
    var query := PhysicsRayQueryParameters3D.create(from, to, collision_mask)
    return camera.get_world_3d().direct_space_state.intersect_ray(query)
