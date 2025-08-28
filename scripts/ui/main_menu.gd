class_name MainMenuControl
extends Control

signal host_game_pressed
signal join_game_pressed(code: String, username: String)
signal settings_pressed

@export var host_game_button : Button
@export var join_game_button : Button
@export var settings_button : Button

@export var join_game_with_string: JoinGameWithString

@export var main_menu_container : Control
@export var join_with_code_container : Control

@export var automatically_set_game_title := true

var _name := ""

func _ready() -> void:
    host_game_button.pressed.connect(func():
        host_game_pressed.emit()
    )
    
    join_game_button.pressed.connect(func():
        main_menu_container.visible = false
        join_with_code_container.visible = true
    )
    
    join_game_with_string.pressed.connect(func(code: String, username: String):
        _name = username
        join_game_pressed.emit(code, username)
    )
    
    join_game_with_string.cancel.connect(func():
        main_menu_container.visible = true
        join_with_code_container.visible = false
    )
    
    settings_button.pressed.connect(func():
        settings_pressed.emit()    
    )
    
    if automatically_set_game_title:
        var title_node := get_node_or_null("%GameTitle")
        if title_node:
            title_node.text = ProjectSettings.get_setting("application/config/name")
