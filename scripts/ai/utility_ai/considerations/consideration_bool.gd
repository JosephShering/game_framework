class_name ConsiderationBool
extends Consideration

@export var key : StringName

@export_group("Bool Operation")
@export var NOT := false

func consider(world: Dictionary) -> float:
    var v : bool = world.get(key, false)
    
    if NOT:
        v = !v
    
    if v:
        return 1.0
    else:
        return 0
