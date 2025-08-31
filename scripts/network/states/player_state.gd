class_name PlayerState
extends Node

@export var synchronizer : MultiplayerSynchronizer

var id := -1
var display_name := "[UNKNOWN]"

var position : Vector3
var rotation : Vector3

var timestamp := 0

func get_ticks_per_second() -> float:
    return 1.0 / synchronizer.replication_interval

func _ready() -> void:
    synchronizer.synchronized.connect(_on_synchronized)
    
func _on_synchronized() -> void:
    timestamp = Time.get_ticks_msec()
