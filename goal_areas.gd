extends Area2D

signal score


func _on_body_entered(body: Node2D) -> void:
	if body is Frog:
		print("score!")
	emit_signal("score")
