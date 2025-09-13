class_name BaseGameManager
extends Node

var game_mode : GameMode

func get_game_mode() -> GameMode:
    return game_mode

func get_level() -> Node3D:
    return get_node(game_mode.spawn_path)

func register_game_mode(_game_mode: GameMode) -> void:
    game_mode = _game_mode
