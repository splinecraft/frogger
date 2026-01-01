class_name PlatformComponent
extends Node

@export var area_2d: Area2D
@export var animated_sprite2d: AnimatedSprite2D

var on_platform: bool = false
var frog_ref: Node2D = null
var lane: Area2D = null

func _ready() -> void:
	lane = get_parent().get_parent()
	
func _physics_process(delta: float) -> void:
	pass


func _on_body_entered(body):
	on_platform = true
	lane.carries_frog = true
	#frog_ref = body
	

func _on_body_exited(body):
	on_platform = false
	lane.carries_frog = false
	#frog_ref = null
	
