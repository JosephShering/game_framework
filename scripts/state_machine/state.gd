class_name State
extends Node

var enter_fn: Callable
var exit_fn: Callable
var tick_fn: Callable

func on_enter(callable: Callable) -> State:
    enter_fn = callable
    return self
    
func on_exit(callable: Callable) -> State:
    exit_fn = callable
    return self
    
func on_tick(callable: Callable) -> State:
    tick_fn = callable
    return self

func enter() -> void:
    enter_fn.call()
    
func tick(delta: float) -> void:
    tick_fn.call(delta)
    
func exit() -> void:
    exit_fn.call()

func _init() -> void:
    enter_fn = func() -> void: pass
    exit_fn = func() -> void: pass
    tick_fn = func(_delta: float) -> void: pass
