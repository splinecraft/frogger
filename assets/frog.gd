extends CharacterBody2D

@onready var frog_sprite: AnimatedSprite2D = $FrogSprite
@onready var death_timer: Timer = $DeathTimer
@onready var frog_area_2d: Area2D = $FrogArea2D
@onready var body_collision: CollisionShape2D = $BodyCollision
@onready var area_2d_collision: CollisionShape2D = $FrogArea2D/Area2DCollision


const JUMP_TIME := 0.1
const STEP := 16

var is_moving := false
var target_pos: Vector2
var jump_tween: Tween
var on_platform: bool = false
var in_water: bool = false
var frog_spawn_pos: Vector2
var death_ip: bool = false
var input_enabled: bool = true

func _ready() -> void:
	frog_area_2d.body_entered.connect(_on_body_entered)
	death_timer.timeout.connect(respawn)
	frog_spawn_pos = get_parent().get_node("FrogSpawn").global_position


func _process(delta: float) -> void:
	if is_moving or not input_enabled:
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
	if body.is_in_group("Enemy") and not death_ip:
		vehicle_death()
	
	
func apply_lane_motion(motion: Vector2):
	global_position += motion
	
func vehicle_death():
	input_enabled = false
	print("run over!")
	death_ip = true
	frog_area_2d.monitoring = false
	area_2d_collision.disabled = true
	body_collision.disabled = true
	frog_sprite.play("car_death")
	death_timer.start()
	
func respawn():
	frog_sprite.play("idle")
	position = frog_spawn_pos
	frog_area_2d.monitoring = true
	body_collision.disabled = false
	area_2d_collision.disabled = false
	death_ip = false
	input_enabled = true
