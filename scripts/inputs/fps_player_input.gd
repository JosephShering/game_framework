class_name FPSPlayerInput
extends PlayerInput

signal jumped
signal attacked

var jump_action := &"jump"
var camera_zoom_in_action := &"camera_zoom_in"
var camera_zoom_out_action := &"camera_zoom_out"
var move_to_action := &"move_to"
var interact_action := &"interact"
var attack := &"attack"

var move_left_action := &"move_left"
var move_right_action := &"move_right"
var move_forward_action := &"move_forward"
var move_backward_action := &"move_backward"

var viewport : Viewport
var move_dir := Vector2.ZERO ## The camera aligned move direction
var move_input := Vector2.ZERO: ## Raw vector input
    set(new_move):
        move_input = new_move
        var camera := viewport.get_camera_3d()
        move_dir = move_input.rotated(
            -camera.global_rotation.y
        )
var zoom := 0.0
var jump := false
var interact := false

func process_input(event: InputEvent) -> void:
    super.process_input(event)
    jump = event.is_action_pressed(jump_action)
    if jump:
        jumped.emit()
    
    interact = event.is_action_pressed(interact_action)
    
    var zoom_strength := 0.0
    if event.is_action_pressed(camera_zoom_in_action):
        zoom_strength += 1.0
    
    if event.is_action_pressed(camera_zoom_out_action):
        zoom_strength -= 1.0
        
    if event.is_action_pressed(attack):
        attacked.emit()
        
    zoom = zoom_strength

func process_physics(delta: float) -> void:
    super.process_physics(delta)
    
    move_input = Input.get_vector(
        move_left_action,
        move_right_action,
        move_forward_action,
        move_backward_action
    )
    
    _reset.call_deferred()

func ready() -> void:
    gimbal = gimbal.from_rotation(initial_rotation)

static func create(v: Viewport) -> FPSPlayerInput:
    var input := FPSPlayerInput.new()
    input.viewport = v
    
    return input

func _reset() -> void:
    move_input = Vector2.ZERO
    jump = false
