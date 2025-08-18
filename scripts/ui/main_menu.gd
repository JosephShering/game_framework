class_name MainMenuControl
extends Control

signal host_game_pressed
signal join_game_pressed
signal settings_pressed

@export var host_game_button : Button
@export var join_game_button : Button
@export var settings_button : Button

@export var automatically_set_game_title := true

func _ready() -> void:
    host_game_button.pressed.connect(func():
        host_game_pressed.emit()
    )
    
    join_game_button.pressed.connect(func():
        join_game_pressed.emit()   
    )
    
    settings_button.pressed.connect(func():
        settings_pressed.emit()    
    )
    
    if automatically_set_game_title:
        var title_node := get_node_or_null("%GameTitle")
        if title_node:
            title_node.text = ProjectSettings.get_setting("application/config/name")
