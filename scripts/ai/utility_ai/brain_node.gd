class_name BrainNode
extends Node

signal choice_changed(choice: Choice)

@export var brain : Brain
@export var rate := 0.3

var world := {}
var choice : Choice

var _rate := INF

func get_choice() -> String:
    if choice:
        return choice.name
    else:
        return ""

func _physics_process(delta: float) -> void:
    if _rate < rate:
        _rate += delta
    else:
        var new_choice := brain.reason(world)
        
        if choice != new_choice:
            choice = new_choice
            choice_changed.emit(choice)
        
        _rate = 0.0
