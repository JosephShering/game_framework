class_name SimpleFPSInteractRichTextLabel
extends RichTextLabel

@export var character : SimpleFPSCharacter

func _ready() -> void:
    visible = false
    
    character.hovered.connect(func(result, label):
        set_text(label)
        visible = true
    )
    
    character.unhovered.connect(func():
        set_text("")
        visible = false
    )
