class_name LevelSpawnWatcher
extends MultiplayerSpawner

func _ready() -> void:
    spawned.connect(func(node: Node):
        LevelLoader.loaded.emit()
    )
