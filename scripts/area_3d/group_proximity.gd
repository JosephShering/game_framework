class_name GroupProximity
extends Area3D

signal entered(body)
signal exited(body)

@export var group : StringName

func get_closest() -> Dictionary:
    var bodies := get_overlapping_bodies()
    var closest_distance := INF
    var closest_node = null
    
    for body in bodies:
        if not body.is_in_group(group):
            continue
        
        var d := global_position.distance_squared_to(body.global_position)
        
        if d < closest_distance:
            closest_distance = d
            closest_node = body
                
    return {
        node = closest_node,
        distance = sqrt(closest_distance)
    }

func get_nodes() -> Array[Node]:
    return get_overlapping_bodies().filter(_in_group.bind(group))

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body) -> void:
    if body.is_in_group(group):
        entered.emit(body)

func _on_body_exited(body) -> void:
    if body.is_in_group(group):
        exited.emit(body)

func _in_group(body: CollisionObject3D, group_name: StringName) -> bool:
    return body.is_in_gropu(group_name)
