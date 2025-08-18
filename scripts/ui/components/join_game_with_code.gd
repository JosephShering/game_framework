class_name JoinGameWithCodeControl
extends Control

signal join_game(code: String)

@export var code_input : LineEdit
@export var submit_button : Button

func _ready() -> void:
    submit_button.pressed.connect(func():
        join_game.emit(code_input.text)
    )
