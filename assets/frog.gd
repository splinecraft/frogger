extends CharacterBody2D

@onready var frog_sprite: AnimatedSprite2D = $FrogSprite
@onready var area_2d: Area2D = $Area2D

const JUMP_TIME := 0.1
const STEP := 16

var is_moving := false
var target_pos: Vector2
var jump_tween: Tween
var on_platform: bool = false
var in_water: bool = false

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	if is_moving:
		return
	
	var dir := get_input_direction()
	if dir != Vector2.ZERO:
		try_start_move(dir)


func get_input_direction() -> Vector2:
	if Input.is_action_just_pressed("left"):
		frog_sprite.rotation_degrees = -90.0
		return Vector2.LEFT
	elif Input.is_action_just_pressed("right"):
		frog_sprite.rotation_degrees = 90.0
		return Vector2.RIGHT
	elif Input.is_action_just_pressed("up"):
		frog_sprite.rotation_degrees = 0.0
		return Vector2.UP
	elif Input.is_action_just_pressed("down"):
		frog_sprite.rotation_degrees = -180.0
		return Vector2.DOWN
	return Vector2.ZERO
	
	
func try_start_move(dir: Vector2):
	var motion := dir * STEP
	
	target_pos = global_position + motion
	start_jump(target_pos)
	
	
func start_jump(target_pos: Vector2):
	is_moving = true
	
	# interrupt the jump and restart if new input arrives - feels more responsive
	if jump_tween and jump_tween.is_running():
		jump_tween.kill()
	
	frog_sprite.play("jump")
	
	jump_tween = create_tween()
	jump_tween.tween_property(self, "global_position", target_pos, JUMP_TIME).set_trans(Tween.TRANS_SINE)
	jump_tween.finished.connect(_on_jump_finished)
	
	
func _on_jump_finished():
	is_moving = false
	frog_sprite.play("idle")
	
	
func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		print("run over!")
	
	
func apply_lane_motion(motion: Vector2):
	global_position += motion
