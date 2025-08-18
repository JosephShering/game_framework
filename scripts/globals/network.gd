extends Node

var type : BaseNetworkType

func _ready() -> void:
    if OS.has_feature("editor"):
        type = LocalNetworkType.new()
    else:
        type = SteamNetworkType.new()
    
    add_child(type)

func host_game(port: int) -> int:
    type.host_game(port)
    
    return 0
    
func join_game(id: int) -> void:
    type.join_game(id)
    
func invite(player_id: int) -> void:
    type.invite(player_id)
    
func accept_invite(player_id: int) -> void:
    type.accept_invite(player_id)
    
func request_to_join() -> void:
    pass
