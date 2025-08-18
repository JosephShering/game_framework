class_name Lerp
extends RefCounted

static func blend(power: float, delta: float) -> float:
    return 1.0 - pow(0.5, power * delta)
