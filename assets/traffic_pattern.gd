class_name TrafficPattern
extends Resource

@export var pattern: String  # example C__C___ means car, 2 spaces, car, 3 spaces
@export var object_scene: PackedScene
@export var spacing_pixels: int = 16		#width of one pattern unit
@export var loop: bool = true
