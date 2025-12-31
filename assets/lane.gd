extends Area2D

signal spawn_tick

@export var speed: float = 0.0
@export var spawn_pos: Vector2
@export var direction: Vector2 = Vector2.ZERO
@export var carries_frog: bool = false
@export var traffic_pattern: TrafficPattern

@onready var spawn_position: Marker2D = %SpawnPosition

var bodies_in_lane : Array[Node2D] = []
var pattern_index: int = 0
var distance_accum: float = 0.0


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	spawn_tick.connect(_on_lane_spawn_tick)
	spawn_position.position = spawn_pos
	
	
func _physics_process(delta: float) -> void:
	if not traffic_pattern:
		return
		
	distance_accum += speed * delta
	
	if distance_accum >= traffic_pattern.spacing_pixels:
		distance_accum -= traffic_pattern.spacing_pixels
		emit_signal("spawn_tick")	
	
func _on_lane_spawn_tick() -> void:
	var char = traffic_pattern.pattern[pattern_index]
	
	if char == "C":
		spawn_object()
		
	pattern_index += 1
	if pattern_index >= traffic_pattern.pattern.length():
		if traffic_pattern.loop:
			pattern_index = 0
		else:
			set_physics_process(false)	
	
func spawn_object():
	var object = traffic_pattern.object_scene.instantiate()
	add_child(object)
	object.global_position = Vector2(spawn_position.global_position)
	
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
