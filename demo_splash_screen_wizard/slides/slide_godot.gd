extends SplashScreenSlide


func _slide() -> void:
	var animation_player = %AnimationPlayer
	animation_player.play("wiggle")
	await animation_player.animation_finished
	slide_finished.emit()