class_name SimpleTopdownCharacter
extends SmoothCharacterBody

var input := FPSPlayerInput.new()

func _input(event: InputEvent) -> void:
    input.process_input(event)

func _unhandled_input(event: InputEvent) -> void:
    input.process_unhandled_input(event)

func _physics_process(delta: float) -> void:
    super.process_physics(delta)
    input.process_physics(delta)
    move_dir = input.move
    
    if _can_jump():
        jump()
    
    move_and_slide()

func _can_jump():
    return is_on_floor() and input.jump
