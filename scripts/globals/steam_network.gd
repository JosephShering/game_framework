class_name SteamNetwork
extends Node

signal lobby_created()
signal game_ready()

var _lobby_id := -1
var players := {}

func _ready() -> void:
    Steam.steamInitEx(480, false)
    Steam.lobby_joined.connect(_on_lobby_joined)
    Steam.lobby_created.connect(_on_lobby_created)
    Steam.join_requested.connect(_on_join_requested)
    Steam.lobby_chat_update.connect(_on_lobby_chat_update)

func _process(delta: float) -> void:
    Steam.run_callbacks()

func create_lobby() -> void:
    Steam.createLobby(Steam.LobbyType.LOBBY_TYPE_FRIENDS_ONLY, 4)

func join_lobby(id: int) -> void:
    Steam.joinLobby(id)

func open_invite_window() -> void:
    Steam.activateGameOverlayInviteDialog(get_lobby_id())

func invite(lobby_id: int, user_id: int) -> void:
    Steam.inviteUserToLobby(get_lobby_id(), user_id)

func open_friends_in_game_window() -> void:
    Steam.activateGameOverlay("players")

func start_game() -> void:
    pass

func get_lobby_id() -> int:
    return _lobby_id

func _on_lobby_joined(lobby_id: int, permission: int, locked: bool, response: int) -> void:
    _lobby_id = lobby_id

func _on_lobby_created(connect: int, lobby_id: int) -> void:
    _lobby_id = lobby_id
    lobby_created.emit()

func _on_join_requested(lobby_id: int, steam_id: int) -> void:
    join_lobby(lobby_id)

func _on_lobby_chat_update(lobby_id: int, changed_id: int, making_change_id: int, chat_state: int) -> void:
    var member_count := Steam.getNumLobbyMembers(lobby_id)
    
    print("CURRENT MEMBERS %d" % member_count)
