class_name Cooldown
extends RefCounted

signal ready

var tree : SceneTree
var timeout := INF
var _time := INF
var paused := false

func start() -> void:
    _time = 0.0

func pause() -> void:
    paused = true

func stop() -> void:
    paused = true
    _time = 0.0

func tick(delta: float) -> void:
    if not paused:
        _time += delta
    
static func cooldown(time: float) -> Cooldown:
    var c := Cooldown.new()
    c.timeout = time
    
    return c
