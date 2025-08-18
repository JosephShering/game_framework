class_name Brain
extends Resource

@export var name : String
@export var choices : Array[Choice]

var weights := {}

func reason(world: Dictionary) -> Choice:
    var best_choice : Choice
    var highest_weight := 0.0
    
    for choice in choices:
        var weight := choice.weigh(world)
        weights[choice.name] = weight
        
        if weight > highest_weight:
            highest_weight = weight
            best_choice = choice
    
    return best_choice
