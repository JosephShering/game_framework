class_name MainBootstrap
extends Node

@export_file("*.tscn") var default_level : String

@export var loading_screen : Control

func _ready() -> void:
    LevelLoader.loading_screen = loading_screen.get_path()
