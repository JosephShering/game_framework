extends Node

## These values needs to be human readable

@export var mouse_sensitivity := 0.5
@export var camera_fov := 88

@export_group("Graphics")
@export var display : int = 0
@export_enum("Windowed Fullscreen", "Windowed", "Fullscreen") var window := "Windowed Fullscreen"
@export var frame_rate_cap := 60
@export_enum("MSAA", "FXAA") var anti_aliasing := "FXAA"
@export var vsync := false

@export_group("Audio")
@export var music_volume := 100
@export var sound_effects := 100
@export var dialogue := 100

var resolutions : Dictionary[String, Vector2i] = {
    "3440x1440": Vector2i(3440, 1440),
    "2560x1440": Vector2i(2560, 1440),
    "1920x1080": Vector2i(1920, 1080),
    "800x600": Vector2i(800, 600)
}

func calculate_settings() -> void:
    frame_rate_cap = DisplayServer.screen_get_refresh_rate(display)
    var screen_size := DisplayServer.screen_get_size(display)
