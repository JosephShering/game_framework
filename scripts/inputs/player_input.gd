class_name PlayerInput
extends AuthorityNode

signal attack

signal interact_pressed
signal interact_hold
signal interact_hold_released
signal interact_released

signal jump
signal drop
signal toggle_crafting_menu

var move_dir := Vector2.ZERO
var move_input := Vector2.ZERO:
    set(_move_input):
        move_input = _move_input
        var camera := get_viewport().get_camera_3d()
        move_dir = move_input.rotated(
            -camera.global_rotation.y
        )
    
var mouse_relative := Vector2.ZERO
var gimbal := Gimbal.new()
var interact_hold_action := HoldAction.new(&"interact", 0.35)

func is_attacking() -> bool:
    return Input.is_action_pressed(&"attack")

func _local_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        mouse_relative = event.relative
    
    _handle_interact(event)
    _handle_crafting_menu(event)
    _handle_jump(event)
    _handle_drop(event)
    _handle_attack(event)
            
func _local_ready() -> void:
    gimbal = Gimbal.from_rotation(get_parent().rotation)
    
    interact_hold_action.held.connect(interact_hold.emit)
    
func _local_physics_process(delta: float) -> void:
    _process_move_vector()
    
    interact_hold_action.tick(delta)
    
    gimbal.rotate_outer_gimbal(mouse_relative.x)
    gimbal.rotate_inner_gimbal(mouse_relative.y)
    
    _reset_mouse_relative.call_deferred()

func _handle_interact(event: InputEvent) -> void:
    if event.is_action_pressed(&"interact"):
        interact_pressed.emit()
        
    if event.is_action_released(&"interact"):
        if interact_hold_action.is_holding():
            interact_hold_released.emit()
        else:
            interact_released.emit()

func _handle_crafting_menu(event: InputEvent) -> void:
    if event.is_action_pressed(&"crafting_menu"):
        toggle_crafting_menu.emit()

func _handle_jump(event: InputEvent) -> void:
    if event.is_action_pressed(&"jump"):
        jump.emit()

func _handle_drop(event: InputEvent) -> void:
    if event.is_action_pressed(&"drop"):
        drop.emit()

func _handle_attack(event: InputEvent) -> void:
    if event.is_action_pressed(&"attack"):
        attack.emit()

func _process_move_vector() -> void:
    move_input = Input.get_vector(
        &"move_left",
        &"move_right",
        &"move_forward",
        &"move_backward"
    )
    
func _reset_mouse_relative() -> void:
    mouse_relative = Vector2.ZERO

func _handle(event: InputEvent, action: StringName, signal_callable: Signal) -> void:
    if event.is_action_pressed(action):
        signal_callable.emit()
