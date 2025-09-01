class_name ClickToMoveInput
extends PlayerInput

var jump_action := &"jump"
var camera_zoom_in_action := &"camera_zoom_in"
var camera_zoom_out_action := &"camera_zoom_out"
var move_to_action := &"move_to"

signal move_to(position: Vector3)
signal picked(result: Dictionary)

var zoom := 0.0
var jump := false

var pick_distance := 50.0
var viewport : Viewport

func process_input(event: InputEvent) -> void:
    super.process_input(event)
    jump = event.is_action_pressed(jump_action)
    
    var zoom_strength := 0.0
    if event.is_action_pressed(camera_zoom_in_action):
        zoom_strength += 1.0
    
    if event.is_action_pressed(camera_zoom_out_action):
        zoom_strength -= 1.0
        
    if event.is_action_pressed(move_to_action):
        var screen_position := viewport.get_mouse_position()
        var camera := viewport.get_camera_3d()
        
        var from := camera.project_ray_origin(screen_position)
        var to := camera.project_ray_origin(screen_position) + camera.project_ray_normal(screen_position) * pick_distance
        var query := PhysicsRayQueryParameters3D.create(from, to)
        var result := camera.get_world_3d().direct_space_state.intersect_ray(query)
        
        if result != {}:
            var coll: Node = result["collider"]
            
            if coll.is_in_group(&"nav_surface"):
                move_to.emit(result["position"])
            
            picked.emit(result)
            
    zoom = zoom_strength

static func create(viewport: Viewport) -> ClickToMoveInput:
    var i := ClickToMoveInput.new()
    i.viewport = viewport
    
    return i
