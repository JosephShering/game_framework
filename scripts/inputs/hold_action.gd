class_name HoldAction
extends Resource

signal held

var sm := SM.new()

var _hold_time := 0.0
var _is_holding := false

func is_holding() -> bool:
    return _is_holding

func _init(action_name: StringName, hold_timeout: float) -> void:
    var idle_state := State.new().on_tick(func(delta: float):
        if Input.is_action_pressed(&"interact"):
            sm.go_to("pressed")
    )
    
    var pressed_state := State.new().on_tick(func(delta: float):
        if Input.is_action_pressed(&"interact"):
            _hold_time += delta
            
        if _hold_time > hold_timeout:
            sm.go_to("holding")
    ) \
    .on_exit(func():
        _hold_time = 0.0
    )
    
    var holding_state := State.new() \
    .on_enter(func():
        _hold_time = 0.0
        _is_holding = true
        held.emit()
    ) \
    .on_tick(func(delta: float):
        if Input.is_action_just_released(&"interact"):
            sm.go_to("idle")
    ) \
    .on_exit(func(): _is_holding = false)
    
    var released := State.new()
    
    sm.add("idle", idle_state)
    sm.add("pressed", pressed_state)
    sm.add("holding", holding_state)
    sm.initial_state("idle")

func tick(delta: float) -> void:
    sm.tick(delta)
