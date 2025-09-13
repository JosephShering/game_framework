class_name GameMode
extends Node3D

@export var spawn_path : NodePath

@export_file var player_scene : String

func get_spawn_path() -> NodePath:
    return spawn_path
    
func get_spawn_node() -> Node3D:
    return get_node(spawn_path)

@rpc("any_peer", "reliable")
func create_player(peer_id : int = multiplayer.get_remote_sender_id()) -> Node3D:
    if !is_multiplayer_authority(): return null
    
    var player : Node = load(player_scene).instantiate()
    
    player.name = str(peer_id)
    player.set_multiplayer_authority(peer_id)
    
    var spawn_node := get_node(spawn_path)
    spawn_node.add_child(player, true)
    
    return player

func spawn(node: Node) -> void:
    get_spawn_node().add_child(node, true)

func _enter_tree() -> void:
    GameManager.register_game_mode(self)
