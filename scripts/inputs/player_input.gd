class_name PlayerInput
extends RefCounted

const MOUSE_SENSITIVITY := 0.005

var mouse_look_input := Vector2.ZERO

var gimbal := Gimbal.new()

func create(rotation: Vector3) -> void:
    gimbal = Gimbal.from_rotation(rotation)

func process_unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        mouse_look_input = -event.relative * MOUSE_SENSITIVITY * Settings.mouse_sensitivity
        gimbal.rotate_outer_gimbal(mouse_look_input.x)
        gimbal.rotate_inner_gimbal(mouse_look_input.y)
    
func process_physics(delta: float) -> void:
    gimbal.tick(delta)
    
    _reset_mouse_move.call_deferred()

func _reset_mouse_move() -> void:
    mouse_look_input = Vector2.ZERO
