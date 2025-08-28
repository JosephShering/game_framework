class_name QuickUsername
extends LineEdit

func save() -> void:
    var f := FileAccess.open("user://username.txt", FileAccess.WRITE)
    f.store_line(text)

func _ready() -> void:
    var f := FileAccess.open("user://username.txt", FileAccess.READ)
    
    if f:
        text = f.get_line()
