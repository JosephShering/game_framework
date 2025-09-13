class_name Vector
extends RefCounted

static func random() -> Vector3:
    return Vector3(
            randf_range(-1.0, 1.0),
            randf_range(-1.0, 1.0),
            randf_range(-1.0, 1.0)
        ).normalized()
