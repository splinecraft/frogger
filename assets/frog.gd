extends CharacterBody2D

@onready var frog_sprite: AnimatedSprite2D = $FrogSprite

const JUMP_TIME := 0.1
const STEP := 16

var is_moving := false
var target_pos: Vector2
var jump_tween: Tween

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
	
	if test_move(global_transform, motion):
		return
	
	#no collision, commit to smooth movement
	target_pos = global_position + motion
	start_jump(target_pos)
	#is_moving = true
	
	#var tween := create_tween()
	#tween.tween_property(self, "global_position", target_pos, 0.12).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	#tween.finished.connect(func(): is_moving = false)
	#frog_sprite.play("jump")
	
func start_jump(target_pos: Vector2):
	is_moving = true
	
	if jump_tween and jump_tween.is_running():
		jump_tween.kill()
	
	frog_sprite.play("jump")
	
	jump_tween = create_tween()
	jump_tween.tween_property(self, "global_position", target_pos, JUMP_TIME).set_trans(Tween.TRANS_SINE)
	jump_tween.finished.connect(_on_jump_finished)
	
func _on_jump_finished():
	is_moving = false
	frog_sprite.play("idle")
