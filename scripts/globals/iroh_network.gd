extends Node

signal peer_connected
signal peer_disconnected
signal connected_to_server
signal connection_failed
signal server_disconnected

const PLAYERS_CONTAINER = "/root/Main/Level"
const LEVEL_CONTAINER = "/root/Main/Level"
const CHARACTER = preload("res://scenes/topdown_character.tscn")
var connection_string := ""

func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)
    multiplayer.connected_to_server.connect(_on_connected_to_server)
    multiplayer.connection_failed.connect(_on_connection_failed)
    multiplayer.server_disconnected.connect(_on_server_disconnected)
    
func create() -> void:
    var peer := IrohServer.start()
    
    connection_string = peer.connection_string()
    
    multiplayer.multiplayer_peer = peer
    DisplayServer.clipboard_set(connection_string)
    
    
func join(str: String) -> void:
    var peer := IrohClient.connect(str)
    connection_string = str
    
    multiplayer.multiplayer_peer = peer

@rpc("any_peer", "reliable")
func create_player() -> void:
    var remote_id := multiplayer.get_remote_sender_id()
    _add_player(remote_id)

func get_connection_string() -> String:
    return connection_string

func _on_peer_connected(new_peer_id: int) -> void: #happens for clients who also just connected...
    peer_connected.emit(new_peer_id)
    
func _on_peer_disconnected(id: int) -> void:
    _remove_player(id)
    peer_disconnected.emit(id)

func _on_connected_to_server() -> void:
    connected_to_server.emit()

func _on_connection_failed() -> void:
    connection_failed.emit()

func _on_server_disconnected() -> void:
    server_disconnected.emit()

func _exit_tree() -> void:
    if multiplayer.is_server():
        multiplayer.multiplayer_peer.close()

func _is_connected() -> bool:
    return multiplayer.has_multiplayer_peer() and multiplayer.get_multiplayer_peer().get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED

func _add_player(new_peer_id: int) -> Node:
    var players_container := get_node(PLAYERS_CONTAINER)
    var player := CHARACTER.instantiate()
    player.name = str(new_peer_id)
    player.set_multiplayer_authority(new_peer_id)
    players_container.add_child(player, true)
    
    return player

func _get_player(peer_id: int) -> Node:
    var players_container := get_node(PLAYERS_CONTAINER)
    var player_node := players_container.get_node_or_null(str(peer_id))
    
    return player_node

func _remove_player(peer_id: int) -> void:
    var players_container := get_node(PLAYERS_CONTAINER)
    var maybe_player := players_container.get_node_or_null(str(peer_id))
    
    if maybe_player:
        players_container.remove_child(maybe_player)
        maybe_player.queue_free()
