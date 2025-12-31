extends Node2D

@onready var frog: CharacterBody2D = $Frog
@onready var road_01: Area2D = %Road_01
@onready var road_02: Area2D = %Road_02
@onready var road_03: Area2D = %Road_03
@onready var road_04: Area2D = %Road_04
@onready var road_05: Area2D = %Road_05
@onready var water_01: Area2D = %Water_01
@onready var water_02: Area2D = %Water_02
@onready var water_03: Area2D = %Water_03
@onready var water_04: Area2D = %Water_04
@onready var water_05: Area2D = %Water_05

@onready var lanes : Array[Area2D] = [
	road_01,
	road_02,
	road_03,
	road_04,
	road_05,
	water_01,
	water_02,
	water_03,
	water_04,
	water_05
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
