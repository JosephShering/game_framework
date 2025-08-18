class_name ConsiderationCurve
extends Consideration

@export var key : String
@export var curve : Curve

func consider(world: Dictionary) -> float:
    var value : float = world.get(key, 0.0)
    var idx = clampf(value, curve.min_domain, curve.max_domain)
    
    return curve.sample_baked(idx)
