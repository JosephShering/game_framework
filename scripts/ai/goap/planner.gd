class_name Planner
extends RefCounted

var actions : Array[Action] = []
var star := AStar3D.new()

func add(actions: Array[Action]) -> void:
    actions.append_array(actions)

func plan(goal: Goal, blackboard: Dictionary) -> Array[Action]:
    for action in actions:
        var preconditions := action.get_preconditions()
        var effects := action.get_effects()
        
        var desired_state := goal.get_desired_state()
        
        
        
    return []
