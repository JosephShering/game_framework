class_name Choice
extends Resource

@export var name : String
@export var considerations : Array[Consideration]

func weigh(world: Dictionary) -> float:
    var sum : float = 0.0
    var total_considerations : int = 0
    
    for c in considerations:
        var consideration_value : float = c.consider(world)
        sum += consideration_value * float(c.weight)
        total_considerations += c.weight
    
    return sum / float(total_considerations)
