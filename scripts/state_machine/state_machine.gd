class_name SM
extends RefCounted

var states : Dictionary[String, State] = {}
var current : String

func go_to(to: String) -> void:
    _change(to)

func add(name: String, state: State) -> SM:
    states[name] = state
    
    return self

func initial_state(initial_state: String) -> SM:
    current = initial_state
    return self

func tick(delta: float) -> void:
    states[current].tick(delta)

func _on_request_changed(to: String) -> void:
    _change(to)

func _change(to: String) -> void:
    if to == current:
        return
        
    states[current].exit()
    current = to
    states[current].enter()
