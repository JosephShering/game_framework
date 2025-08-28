class_name JoinGameWithString
extends Control

signal pressed(code: String, username: String)
signal cancel

@export var min_character_length := 5

@export var code_line_edit : LineEdit
@export var join_button : Button
@export var back_button : Button

@export var quick_username : QuickUsername

func _ready() -> void:
    join_button.disabled = true
    
    join_button.pressed.connect(func():
        if code_line_edit.text.length() <= min_character_length:
            return
        
        quick_username.save()
        pressed.emit(code_line_edit.text, quick_username.text)    
    )
    
    back_button.pressed.connect(cancel.emit)
    
    code_line_edit.text_changed.connect(func(nt: String):
        if nt.length() > min_character_length:
            join_button.disabled = false
    )
