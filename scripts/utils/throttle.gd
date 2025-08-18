class_name Throttle
extends RefCounted

var callable : Callable
var last_called_at := 0
var time := 1.0
var pending_call := false

func _init(callable: Callable, time: float) -> void:
    self.callable = callable
    self.time = time
    
func invoke(args: Array) -> void:
    if pending_call:
        return
    
    var tick_diff := Time.get_ticks_msec() - last_called_at
    var diff := float(tick_diff) / 1000.0
        
    if diff >= time:
        last_called_at = Time.get_ticks_msec()
        self.callable.callv(args)
        pending_call = false
    else:
        pending_call = true
        
        await Engine.get_main_loop() \
        .create_timer(max(0.0, time - diff)).timeout
        
        self.callable.callv(args)
        pending_call = false
        
static func throttle(callable: Callable, time: float) -> Throttle:
    return Throttle.new(callable, time)
