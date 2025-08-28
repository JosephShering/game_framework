class_name FPSPlayerInput
extends PlayerInput

var move := Vector2.ZERO
var jump := false
var interact := false

func process_input(event: InputEvent) -> void:
    jump = event.is_action_pressed(&"jump")
    interact = event.is_action_pressed(&"interact")
    
func process_physics(delta: float) -> void:
    super.process_physics(delta)
    
    move = Input.get_vector(&"move_left", &"move_right", &"move_forward", &"move_backward")
    _reset_move.call_deferred()

func ready(initial_rotation: Vector3) -> void:
    gimbal = gimbal.from_rotation(initial_rotation)

func _reset_move() -> void:
    move = Vector2.ZERO
