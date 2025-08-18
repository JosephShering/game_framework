class_name SimpleFPSCharacter
extends SmoothCharacterBody

signal hovered(result: Dictionary, label: String)
signal unhovered()

@export var camera : FPSCamera

var input := FPSPlayerInput.new()

var hover_result := {}

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    
    camera.hovered.connect(func(result: Dictionary, label: String):
        hovered.emit(result, label)
        hover_result = result
    )
    
    camera.unhovered.connect(func():
        unhovered.emit()
        hover_result = {}
    )

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
    
    if input.interact:
        var collider := hover_result.get("collider", null)
        if collider and collider.has_method("interact"):
            collider.interact(self)
    
    camera.rotation.x = input.gimbal.get_pitch()
    rotation.y = input.gimbal.get_yaw()
    
    move_and_slide()

func _can_jump() -> bool:
    return is_on_floor() and input.jump
