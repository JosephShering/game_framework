class_name SmoothCharacterBody
extends CharacterBody3D

signal launched
signal landed

enum RotationBehavior {
    none,
    with_velocity,
    move_dir,
    look_dir,
    look_at,
}

@export_group("Ground", "ground_")
@export var ground_base_speed := 300.0
@export var ground_acceleration := 200.0
@export var ground_acceleration_multiplier_curve : Curve

@export_group("Air", "air_")
@export var air_base_speed := 200.0
@export var air_acceleration := 10.0

@export_group("Jump", "jump_")
@export var jump_height := 1.0
@export var jump_to_peak := 0.4
@export var jump_to_ground := 0.35
@export var jump_buffer_time := 0.15

@export_group("Rotation Behavior", "rotation_")
@export var rotation_behavior : RotationBehavior = RotationBehavior.none
@export var rotation_speed := 25.0

@export var camera : TopdownCamera

var id : int

var acceleration := 20.0
var base_speed := 90.0
var move_dir := Vector2.ZERO
var _world_move_dir := Vector2.ZERO
var look_dir := Vector2.ZERO
var look_at := Vector3.ZERO

var gimbal := Gimbal.new()

var jump_pressed_at := 0

var last_is_on_floor := false

func jump(jump_height: float = jump_height, to_peak: float = jump_to_peak) -> void:
    if !is_on_floor() and velocity.y < 0.0:
        jump_pressed_at = Time.get_ticks_msec()
    
    if _can_jump():
        velocity.y = (2.0 * jump_height) / to_peak

@rpc("reliable")
func _jump() -> void:
    jump()

func fall(
    delta: float,
    jump_height: float = jump_height,
    time_to_peak: float = jump_to_peak,
    time_to_ground: float = jump_to_ground,
) -> void:
    var time_to := 0.0
    
    if velocity.y < 0.0:
        time_to = time_to_ground
    else:
        time_to = time_to_peak
    
    velocity.y -= ((2.0 * jump_height) / (time_to * time_to) * delta)

func _ready() -> void:
    id = int(name)
    set_multiplayer_authority(id)
    
    last_is_on_floor = is_on_floor()
    
    if is_multiplayer_authority():
        var spawn_point := get_tree().get_first_node_in_group("spawn_points")
        if spawn_point:
            global_position = spawn_point.global_position
        
        _local_ready()
        
        if camera:
            camera.current = true
    else:
        if camera:
            camera.free()
        
        _remote_ready()

func _input(event: InputEvent) -> void:
    if is_multiplayer_authority():
        _local_input(event)
    else:
        _remote_input(event)

func _unhandled_input(event: InputEvent) -> void:
    if is_multiplayer_authority():
        _local_unhanded_input(event)
    else:
        _remote_unhanded_input(event)

func _physics_process(delta: float) -> void:
    if !last_is_on_floor and is_on_floor():
        var t := Time.get_ticks_msec()
        var diff := float(t - jump_pressed_at) / 1000.0
        
        if diff < jump_buffer_time:
            jump()
        
        landed.emit()
    
    if last_is_on_floor and !is_on_floor():
        launched.emit()
    
    last_is_on_floor = is_on_floor()
    
    if is_multiplayer_authority():
        _local_physics_process(delta)
    else:
        _remote_physics_process(delta)

func _process(delta: float) -> void:
    if is_multiplayer_authority():
        _local_process(delta)
    else:
        _remote_process(delta)

func is_on_ground() -> bool:
    return is_on_floor()

func _lerp_rotation(x: float, z: float, delta: float) -> void:
    if Vector2(x, z).length() <= 0:
        return
    
    var angle := atan2(-x, -z)
    rotation.y = lerp_angle(
        rotation.y,
        angle,
        Lerp.blend(rotation_speed, delta)
    )

func _remote_ready() -> void:
    pass

func _remote_input(event: InputEvent) -> void:
    pass
    
func _remote_unhanded_input(event: InputEvent) -> void:
    pass
    
func _remote_physics_process(delta: float) -> void:
    pass
    
func _remote_process(delta: float) -> void:
    pass

func _local_ready() -> void:
    pass

func _local_input(event: InputEvent) -> void:
    pass
    
func _local_unhanded_input(event: InputEvent) -> void:
    pass
    
func _local_physics_process(delta: float) -> void:
    #region Smooth Rotation
    
    match rotation_behavior:
        RotationBehavior.none:
            pass
        RotationBehavior.with_velocity:
            var v := velocity.normalized()
            _lerp_rotation(v.x, v.z, delta)
        RotationBehavior.move_dir:
            _lerp_rotation(move_dir.x, move_dir.y, delta)
        RotationBehavior.look_dir:
            _lerp_rotation(look_dir.x, look_dir.y, delta)
        RotationBehavior.look_at:
            var dir := global_position.direction_to(Vector3(look_at.x, global_position.y, look_at.z))
            _lerp_rotation(dir.x, dir.z, delta)
    #endregion
    
    #region Ground Movement
    var max_ground_speed := Vector2.ONE.normalized() * base_speed * delta
    var current_ground_velocity := Vector2(velocity.x, velocity.z) 
    
    var acceleration_multiplier := 1.0
    if ground_acceleration_multiplier_curve:
        var offset := current_ground_velocity.length() / max_ground_speed.length()
        acceleration_multiplier = ground_acceleration_multiplier_curve.sample_baked(offset)
    
    var tgv := current_ground_velocity.move_toward(
        move_dir * base_speed * delta,
        acceleration * acceleration_multiplier * delta
    )
    
    velocity.x = tgv.x
    velocity.z = tgv.y
    #endregion
    
    #region Ground vs Falling States
    if is_on_ground():
        base_speed = ground_base_speed
        acceleration = ground_acceleration
    else:
        base_speed = air_base_speed
        acceleration = air_acceleration
        fall(delta)
    #endregion
    
    #region Buffered Jumping
    
    #endregion
    
    gimbal.tick(delta)
    
func _local_process(delta: float) -> void:
    pass

func _can_jump() -> bool:
    return is_on_floor()
