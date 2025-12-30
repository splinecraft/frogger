class_name DeathComponent
extends Node

@export var actor: Node2D
@export var death_anim_time: float
@onready var death_anim_timer: Timer = $DeathAnimTimer
	

func _die_after_anim() -> bool:
	death_anim_timer.start()
	print("dying...")
	death_anim_timer.timeout.connect(func(): actor.queue_free())
	return true


func _die_instantly() -> bool:
	actor.queue_free()
	return true
