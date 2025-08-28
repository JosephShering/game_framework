class_name TopdownCharacter
extends SmoothCharacterBody

@export var sync : MultiplayerSynchronizer

var input := FPSPlayerInput.new()

var _time := 0.0

func _local_input(event: InputEvent) -> void:
    input.process_input(event)

func _local_unhandled_input(event: InputEvent) -> void:
    input.process_unhandled_input(event)

func _local_physics_process(delta: float) -> void:
    super._local_physics_process(delta)
    input.process_physics(delta)
    move_dir = input.move
    
    if _can_jump():
        jump()
    
    move_and_slide()

func _can_jump():
    return is_on_floor() and input.jump
