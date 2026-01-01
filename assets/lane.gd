extends Area2D

signal spawn_tick

@export var speed: float = 0.0
@export var spawn_pos: Vector2
@export var direction: Vector2 = Vector2.ZERO
@export var carries_frog: bool = false
@export var traffic_pattern: TrafficPattern

# for spawning object/gap where gap can be different size than object
# otherwise uses pattern string from traffic pattern resource
@export var use_alt_pattern: bool = false 
@export var alt_pattern_gap: float = 0.0 # if 0 will be set to same distance as object


@onready var spawn_position: Marker2D = %SpawnPosition

var bodies_in_lane : Array[Node2D] = []
var pattern_index: int = 0
var distance_accum: float = 0.0
var alt_pattern: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	spawn_tick.connect(_on_lane_spawn_tick)
	spawn_position.position = spawn_pos
	if use_alt_pattern:
		_setup_alt_pattern()
	

func _setup_alt_pattern():
	# alt pattern is for cases where we want simple alternating of object/gap, but the gap is a 
	# custom size rather than the same length of the object
	if alt_pattern_gap == 0.0:
			alt_pattern_gap = traffic_pattern.spacing_pixels
	alt_pattern = true	# on/off switch for if we're on an object or a gap
	traffic_pattern.pattern = "C" # logic for alt pattern takes care of gaps so no need to define
	
	
func _physics_process(delta: float) -> void:
	if not traffic_pattern:
		return
		
	distance_accum += speed * delta
	
	if use_alt_pattern:
		if alt_pattern:
			if check_distance_accum():
				alt_pattern = not alt_pattern
		else:
			if distance_accum >= alt_pattern_gap:
				distance_accum -= alt_pattern_gap
				alt_pattern = not alt_pattern
	else:
		check_distance_accum()


func check_distance_accum() -> bool:
	if distance_accum >= traffic_pattern.spacing_pixels:
			distance_accum -= traffic_pattern.spacing_pixels
			emit_signal("spawn_tick")
			return true
	else:
		return false


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
