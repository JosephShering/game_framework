class_name AuthorityNode
extends Node

@export var authority : Node

var _process_callable : Callable
var _physics_process_callable : Callable
var _input_callable : Callable

func _ready() -> void:
    if !authority.is_node_ready():
        await authority.ready
    
    if authority.is_multiplayer_authority():
        _local_ready()
        _process_callable = _local_process
        _physics_process_callable = _local_physics_process
        _input_callable = _local_input
    else:
        _remote_ready()
        _process_callable = _remote_process
        _physics_process_callable = _remote_physics_process
        _input_callable = _remote_input

func _process(delta: float) -> void:
    _process_callable.call(delta)

func _physics_process(delta: float) -> void:
    _physics_process_callable.call(delta)
    
func _input(event: InputEvent) -> void:
    _input_callable.call(event)

#region Abstract Functions
func _local_ready() -> void:
    pass
    
func _remote_ready() -> void:
    pass
    
func _local_physics_process(delta: float) -> void:
    pass
    
func _remote_physics_process(delta: float) -> void:
    pass
    
func _local_process(delta: float) -> void:
    pass
    
func _remote_process(delta: float) -> void:
    pass

func _local_input(event: InputEvent) -> void:
    pass
    
func _remote_input(event: InputEvent) -> void:
    pass
#endregion
