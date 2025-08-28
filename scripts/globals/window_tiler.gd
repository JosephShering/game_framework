extends Node

var total_width := 2060
var total_height := 1046

var half_width := total_width / 2
var half_height := total_height / 2

var start_position := Vector2i(689, 197)

var windows := {
    host = start_position,
    client_1 = Vector2i(start_position.x + half_width, start_position.y),
    client_2 = Vector2i(start_position.x, start_position.y + half_height),
    client_3 = Vector2i(start_position.x + half_width, start_position.y + half_height)
}

func _ready() -> void:
    if OS.has_feature("host"):
        get_window().position = windows["host"]
        
    if OS.has_feature("client_1"):
        get_window().position = windows["client_1"]
        
    if OS.has_feature("client_2"):
        get_window().position = windows["client_2"]
        
    if OS.has_feature("client_3"):
        get_window().position = windows["client_3"]
        
    set_size()
        
func set_size() -> void:
    get_window().size = Vector2i(half_width, half_height)
