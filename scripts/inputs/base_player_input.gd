class_name BasePlayerInput
extends Node


func _ready() -> void:
    if get_parent().is_node_ready():
        await get_parent().ready
    
    if get_parent().is_multiplayer_authority():
        _local_ready()
    else:
        _remote_ready()

func _input(event: InputEvent) -> void:
    if get_parent().is_multiplayer_authority():
        _local_input(event)
    else:
        _remote_input(event)

func _physics_process(delta: float) -> void:
    if get_parent().is_multiplayer_authority():
        _local_physics_process(delta)
    else:
        _remote_physics_process(delta)

func _local_ready() -> void:
    pass
    
func _remote_ready() -> void:
    pass
    
func _local_input(event: InputEvent) -> void:
    pass
    
func _remote_input(event: InputEvent) -> void:
    pass
    
func _local_physics_process(delta: float) -> void:
    pass
    
func _remote_physics_process(delta: float) -> void:
    pass
