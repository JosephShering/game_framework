extends Node

signal peer_connected
signal peer_disconnected
signal connected_to_server
signal connection_failed
signal server_disconnected

var connection_string := ""

func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)
    multiplayer.connected_to_server.connect(_on_connected_to_server)
    multiplayer.connection_failed.connect(_on_connection_failed)
    multiplayer.server_disconnected.connect(_on_server_disconnected)
    
func create() -> void:
    #var peer := IrohServer.start()
    var peer := ENetMultiplayerPeer.new()
    peer.create_server(9721)
    
    connection_string = "" #peer.connection_string()
    
    multiplayer.multiplayer_peer = peer
    DisplayServer.clipboard_set(connection_string)
    
    
func join(str: String) -> void:
    #var peer := IrohClient.connect(str)
    var peer := ENetMultiplayerPeer.new()
    connection_string = str
    
    multiplayer.multiplayer_peer = peer

func get_connection_string() -> String:
    return connection_string

func _on_peer_connected(new_peer_id: int) -> void: #happens for clients who also just connected...
    peer_connected.emit(new_peer_id)
    
func _on_peer_disconnected(id: int) -> void:
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
