extends Button

func _ready() -> void:
    if Network.is_multiplayer_authority():
        pressed.connect(func():
            LevelLoader.server_change_level("res://levels/overworld.tscn")
        )
    else:
        visible = false
