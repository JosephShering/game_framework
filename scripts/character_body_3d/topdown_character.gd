class_name TopdownCharacter
extends SmoothCharacterBody

@export var player_state : PlayerState

var _acc_delta := 0.0

func _local_physics_process(delta: float) -> void:
    super._local_physics_process(delta)
    
    player_state.position = position
    player_state.rotation = rotation
    player_state.display_name = name
    player_state.id = int(name)

func _remote_physics_process(delta: float) -> void:
    var idiff := Time.get_ticks_msec() - player_state.timestamp
    var diff := float(idiff) / 1000.0
    var weight := min(1.0, diff / 0.1)
    
    position = position.lerp(
        player_state.position,
        weight
    )
    rotation = rotation.slerp(player_state.rotation, weight)
