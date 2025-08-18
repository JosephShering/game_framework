@tool
extends EditorPlugin

func _enter_tree() -> void:
    add_autoload_singleton("LevelLoader", "res://addons/game_framework/scripts/globals/level_loader.gd")
    add_autoload_singleton("Settings", "res://addons/game_framework/scripts/globals/user_settings.gd")
    add_autoload_singleton("Network", "res://addons/game_framework/scripts/globals/network.gd")

func _exit_tree() -> void:
    remove_autoload_singleton("LevelLoader")
    remove_autoload_singleton("Settings")
    remove_autoload_singleton("Network")
