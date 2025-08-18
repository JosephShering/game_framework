class_name ConsiderationGroup
extends Consideration

@export var name : String
@export_enum("AVG", "MULT") var strategy : String
@export var considerations : Array[Consideration]

func consider(world: Dictionary) -> float:
    match strategy:
        "AVG":
            return _avg(world)
            
        "MULT":
            return _mult(world)
            
        _:
            return 1.0


func _avg(world: Dictionary) -> float:
    var weight := 0
    var total = 0
    
    for c in considerations:
        total += c.weight
        weight += c.consider(world)
        
    return weight / total
    
func _mult(world: Dictionary) -> float:
    var weight := 0
    var total = 0
    
    for c in considerations:
        total += c.weight
        weight *= c.consider(world)
        
    return weight / total
        
