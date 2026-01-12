class_name PlatformComponent
extends Node

@export var area_2d: Area2D
@export var animated_sprite2d: AnimatedSprite2D

var on_platform: bool = false
var frog_ref: Node2D = null
var lane: Area2D = null

func _ready() -> void:
	lane = get_parent().get_parent()
	

func _on_body_entered(body):
	_check_on_platform(body, 1)
	lane.carries_frog = true
	
	

func _on_body_exited(body):
	_check_on_platform(body, -1)
	lane.carries_frog = false
	
	
func _check_on_platform(body, state):
	if body is Frog:
		body.platform_overlap_count += state
		print("on platform count: ", body.platform_overlap_count)
