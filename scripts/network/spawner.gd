class_name SceneSpawner
extends Node

@export var scene : PackedScene
@export var pawn_path : NodePath

func spawn(data: int) -> Node:
    var node := scene.instantiate()
    node.set_multiplayer_authority(data)
    node.name = str(data)
    
    return node

func _ready() -> void:
    if !is_multiplayer_authority():
        peer_ready.rpc_id(1)

@rpc("any_peer", "call_remote", "reliable")
func peer_ready() -> void:
    var remote_id := multiplayer.get_remote_sender_id()
    
    spawn(remote_id)
