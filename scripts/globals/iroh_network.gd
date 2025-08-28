extends Node

signal peer_connected
signal peer_disconnected
signal connected_to_server
signal connection_failed
signal server_disconnected

signal level_loaded(id: int)

enum State {
    disconnected,
    connecting,
    fetching_game_state,
    ready,
}

class PlayerState extends RefCounted:
    var id := -1
    var is_loaded := false
    var display_name := "SERVER"
    var current_level := ""
    
    static func create(id: int) -> PlayerState:
        var ps := PlayerState.new()
        ps.id = id
        
        return ps
    
    func to_byte_array() -> PackedByteArray:
        var ez := EZPacker.new()
        
        ez.s32(id)
        ez.boolean(is_loaded)
        ez.string(display_name)
        ez.string(current_level)
        
        return ez.get_array()
    
    func to_dictionary() -> Dictionary:
        return {
            id = id,
            is_loaded = is_loaded,
            display_name = display_name,
            current_level = current_level
        }
    
    static func from_byte_array(arr: PackedByteArray) -> PlayerState:
        var ez := EZUnpacker.create(arr)
        var ps := PlayerState.new()
        
        ps.id = ez.s32()
        ps.is_loaded = ez.boolean()
        ps.display_name = ez.string()
        ps.current_level = ez.string()
        
        return ps
        
var players : Dictionary[int, PlayerState] = {}
var state := State.disconnected
var connection_string := ""

var discovered_players := 0

func _ready() -> void:
    multiplayer.peer_connected.connect(_on_peer_connected)
    multiplayer.peer_disconnected.connect(_on_peer_disconnected)
    multiplayer.connected_to_server.connect(_on_connected_to_server)
    multiplayer.connection_failed.connect(_on_connection_failed)
    multiplayer.server_disconnected.connect(_on_server_disconnected)

func create() -> void:
    var peer := IrohServer.start()
    players[1] = PlayerState.create(1)
    
    connection_string = peer.connection_string()
    state = State.ready
    
    multiplayer.multiplayer_peer = peer
    DisplayServer.clipboard_set(connection_string)

func join(str: String) -> void:
    var peer := IrohClient.connect(str)
    state = State.connecting
    connection_string = str
    
    multiplayer.multiplayer_peer = peer

func map_player(callable: Callable) -> void:
    var local_id := multiplayer.get_unique_id()
    var modified_player := callable.call(players[local_id])
    
    var player_data : PackedByteArray = modified_player.to_byte_array()
    _update_player.rpc(player_data)

func get_connection_string() -> String:
    return connection_string

func _on_peer_connected(new_peer_id: int) -> void: #happens for clients who also just connected...
    if new_peer_id in players:
        return
    
    players[new_peer_id] = PlayerState.create(new_peer_id)
    
    var local_id := multiplayer.get_unique_id()
    _update_player.rpc_id(new_peer_id, players[local_id].to_byte_array())
    
    peer_connected.emit(new_peer_id)

func _on_peer_disconnected(id: int) -> void:
    players.erase(id)
    peer_disconnected.emit(id)

func _on_connected_to_server() -> void:
    var local_id := multiplayer.get_unique_id()
    players[local_id] = PlayerState.create(local_id)
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

@rpc("any_peer", "call_local", "reliable")
func _update_player(player_bytes: PackedByteArray) -> void:
    var ps := PlayerState.from_byte_array(player_bytes)
    
    players[ps.id] = ps
    
func _pretty_print_state() -> void:
    var d := {}
    for id in players.keys():
        d[id] = players[id].to_dictionary()
        
    print(JSON.stringify(d, " "))
