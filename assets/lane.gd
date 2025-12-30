extends Area2D

enum LaneType {SAFE, ROAD, WATER, GOAL}

@export var lane_type : LaneType
@export var speed: float = 0.0
@export var direction: Vector2 = Vector2.ZERO
@export var carries_frog: bool = false

var bodies_in_lane : Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
func _on_body_entered(body):
	bodies_in_lane.append(body)
	
func _on_body_exited(body):
	bodies_in_lane.erase(body)
	
func apply_lane_motion(delta):
	if speed == 0:
		return
	
	var motion = direction * speed * delta
	for body in bodies_in_lane:
		if body.has_method("apply_lane_motion"):
			if carries_frog or body.name != "Frog":
				body.apply_lane_motion(motion)
