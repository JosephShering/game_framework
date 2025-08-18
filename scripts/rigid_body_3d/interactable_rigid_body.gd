class_name InteractableRigidBody
extends RigidBody3D

func hover() -> String:
    return "Pickup"
    
func unhover() -> void:
    pass

func interact(_from: Node) -> void:
    queue_free()
