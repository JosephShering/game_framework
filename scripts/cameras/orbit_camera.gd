class_name TopdownGimbal
extends Node3D

@export var camera : NodePath

@export var highest_angle := 88.0
@export var lowest_angle := -88.0
@export var starting_angle := 0.0

@export var target : Node

@export var follow_power := 30.0
@export var arm_follow_power := 30.0
@export var distance := 10.0:
    set(nd):
        distance = nd

@export_group("Zoom")
@export var max_zoom := 15.0
@export var min_zoom := 6.0

var spring_arm := SpringArm3D.new()
var target_point := Node3D.new()

var gimbal := Gimbal.new()

func _ready() -> void:
    top_level = true
    
    gimbal = Gimbal.from_rotation(rotation)
    
    spring_arm.spring_length = distance
    spring_arm.shape = SphereShape3D.new()
    spring_arm.shape.radius = 0.25
    
    add_child(spring_arm)
    spring_arm.add_child(target_point)
    
func _physics_process(delta: float) -> void:
    quaternion = gimbal.quaternion
    
    position = position.lerp(target.global_position, Lerp.blend(follow_power, delta))

func set_distance(distance: float) -> void:
    spring_arm.spring_length = distance
