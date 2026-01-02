extends Node2D

@onready var frog: CharacterBody2D = $Frog
@onready var road_buggy: Area2D = %Road_Buggy
@onready var road_tractor: Area2D = %Road_Tractor
@onready var road_sedan: Area2D = %Road_Sedan
@onready var road_racecar: Area2D = %Road_Racecar
@onready var road_semi: Area2D = %Road_Semi
@onready var water_turtle_trio: Area2D = %Water_TurtleTrio
@onready var water_small_log: Area2D = %Water_SmallLog
@onready var water_large_log: Area2D = %Water_LargeLog
@onready var water_turtle_duo: Area2D = %Water_TurtleDuo
@onready var water_med_log: Area2D = %Water_MedLog
@onready var frog_spawn: Marker2D = %FrogSpawn


@onready var lanes : Array[Area2D] = [
	road_buggy,
	road_tractor,
	road_sedan,
	road_racecar,
	road_semi,
	water_turtle_trio,
	water_small_log,
	water_large_log,
	water_turtle_duo,
	water_med_log
]

var in_water : bool = false
var on_platform : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_water and not on_platform:
		print("dead!")
	for lane in lanes:
		lane.apply_lane_motion(delta)
	

func _in_water(body, state) -> void:
	in_water = state
	print("in water: ", state)
	
	
func _on_platform(body, state) -> void:
	on_platform = state
	print("on platform: ", state)
