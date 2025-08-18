class_name Selectable
extends Node

const PIXEL_PERFECT_OUTLINE = preload("res://addons/game_framework/resources/materials/pixel_perfect_outline.tres")

@export var mesh : MeshInstance3D

func select() -> void:
    mesh.material_overlay = PIXEL_PERFECT_OUTLINE
    
func deselect() -> void:
    mesh.material_overlay = null
