class_name Action
extends RefCounted

func is_valid(_blackboard: Dictionary) -> bool:
    return false

func get_cost(_blackboard: Dictionary) -> int:
    return INF

func get_preconditions() -> Dictionary:
    return {}
    
func get_effects() -> Dictionary:
    return {}

func perform(_blackboard: Dictionary, _delta: float) -> void:
    pass
