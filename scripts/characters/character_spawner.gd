@tool
class_name CharacterSpawner
extends Node3D

@export var scene : PackedScene

func spawn(id: int) -> void:
    var player : Node3D = scene.instantiate()
    player.name = str(id)
    player.position = global_position
    player.rotation.y = global_rotation.y
    
    get_tree().current_scene.add_child.call_deferred(player, true)
    

func _ready() -> void:
    if not Engine.is_editor_hint():
        if multiplayer.is_server():
            spawn(1)

func _process(_delta: float) -> void:
    if Engine.is_editor_hint():
        var t := global_transform.scaled_local(Vector3(0.7, 2.0, 0.7))
        t = t.translated(Vector3(0.0, 1.0, 0.0))
        DebugDraw3D.draw_cylinder(
            t,
            Color.CRIMSON
        )
        DebugDraw3D.draw_arrow(
            t.origin,
            t.origin + (-t.basis.z * 1.5),
            Color.CRIMSON,
            0.25
        )
        DebugDraw3D.draw_text(
            t.origin + Vector3(0.0, 0.2, 0.0),
            "PlayerSpawn",
        )
