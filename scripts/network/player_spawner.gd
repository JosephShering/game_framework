class_name LocalAuthorityMultiplayerSpawner
extends MultiplayerSpawner

@export var scene : PackedScene

var local_scene

func _ready() -> void:
    spawn_function = _spawn
    
    if is_multiplayer_authority():
        spawn(multiplayer.get_unique_id())
    else:
        request_spawn.rpc_id(get_multiplayer_authority())
    
@rpc("any_peer", "call_remote", "reliable")
func request_spawn() -> void:
    var remote_id := multiplayer.get_remote_sender_id()
    var node := spawn(remote_id)

func _spawn(id: int) -> Node:
    var node := scene.instantiate()
    node.set_multiplayer_authority(id)
    node.name = str(id)
    
    return node
