extends Node2D

@onready var frog: CharacterBody2D = $Frog
@onready var death_area: Area2D = $DeathArea
@onready var safe_area: Area2D = $SafeArea


var in_water : bool = false
var on_platform : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	death_area.body_entered.connect(_in_water.bind(true))
	death_area.body_exited.connect(_in_water.bind(false))
	safe_area.body_entered.connect(_on_platform.bind(true))
	safe_area.body_exited.connect(_on_platform.bind(false))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if in_water and not on_platform:
		print("dead!")


func _in_water(body, state) -> void:
	in_water = state
	print("in water: ", state)
	
	
func _on_platform(body, state) -> void:
	on_platform = state
	print("on platform: ", state)
