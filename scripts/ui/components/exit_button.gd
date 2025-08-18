class_name ExitButton
extends Button

func _ready() -> void:
    pressed.connect(func():
        get_tree().quit()    
    )
