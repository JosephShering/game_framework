extends Node

signal level_changed
signal progress_changed(amount: float)

signal loaded(node: Node)

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
    var level_container := get_tree().current_scene.get_node_or_null("/root/Main/Level")
    _level_container = level_container
    
    var loading_screen := get_tree().current_scene.get_node_or_null("/root/Main/CanvasLayer/LoadingScreen")
    _loading_screen = loading_screen

func change_level(path: String) -> void:
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
                
            var node := scene.instantiate()
            _level_container.add_child(node)
            
            if node is Level:
                await node.loaded
            
            status = Status.done
            loaded.emit(node)
            
            
        ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
            push_error("Invalid Resource Loaded")
            
        ResourceLoader.THREAD_LOAD_IN_PROGRESS:
            progress_changed.emit(progress[0])
            
        ResourceLoader.THREAD_LOAD_FAILED:
            push_error("Failed to load the next level")
