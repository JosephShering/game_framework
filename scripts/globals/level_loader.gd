extends Node

signal level_changed
signal progress_changed(amount: float)

signal peer_loaded(peer_id: int)

enum Status {
    loading,
    done
}

var status := Status.done
var _path : String = ""

var _level_container : Node3D
var _loading_screen : Node

var progress : Array[float]

var loaded_peers := {}

func _ready() -> void:
    var level_container := get_tree().current_scene.get_node_or_null("%Level")
    #assert(level_container != null, "Main scene must contain a %Level node, ensure you have a Node3D called %Level")
    _level_container = level_container
    
    var loading_screen := get_tree().current_scene.get_node_or_null("%LoadingScreen")
    #assert(loading_screen != null, "Main scene must contain a %LoadingScreen node, ensure you have a Control called %LoadingScreen")
    _loading_screen = loading_screen

func change_to_host_level() -> void:
    _change_to_host_level.rpc_id(1)

func server_change_level(path: String) -> void:
    _server_change_level.rpc(path)

@rpc("any_peer", "call_remote", "reliable")
func _change_to_host_level():
    remote_change_level.rpc_id(
        multiplayer.get_remote_sender_id(),
        _path
    )

@rpc("authority", "call_remote", "reliable")
func remote_change_level(path: String) -> void:
    change_level(path)

@rpc("authority", "call_local", "reliable")
func _server_change_level(path: String) -> void:
    change_level(path)

func change_level(path: String) -> void:
    Network.map_player(func(player: Network.PlayerState):
        player.current_level = path
        player.is_loaded = false
        
        return player
    )
    
    var err := ResourceLoader.load_threaded_request(path, "PackedScene", true)
    if err != OK:
        print("Failed to load")
        
    status = Status.loading
    _path = path
    level_changed.emit()
    

func _physics_process(_delta: float) -> void:
    if status != Status.loading:
        return
    
    var loading_status := ResourceLoader.load_threaded_get_status(_path, progress)
    
    match loading_status:
        ResourceLoader.THREAD_LOAD_LOADED:
            status = Status.done
            var scene : PackedScene = ResourceLoader.load_threaded_get(_path)
            
            for child in _level_container.get_children():
                child.free()
                
            await get_tree().create_timer(0.5).timeout
            
            var node := scene.instantiate()
            _level_container.add_child(node)
            
            status = Status.done
            Network.map_player(func(player: Network.PlayerState):
                player.is_loaded = true
                return player
            )
            
        ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
            push_error("Invalid Resource Loaded")
            
        ResourceLoader.THREAD_LOAD_IN_PROGRESS:
            progress_changed.emit(progress[0])
            
        ResourceLoader.THREAD_LOAD_FAILED:
            push_error("Failed to load the next level")
