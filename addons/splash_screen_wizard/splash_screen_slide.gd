class_name SplashScreenSlide extends Control


signal slide_finished
signal finished


@export var transition_in: SlideTransition
@export var transition_out: SlideTransition
@export var continue_after_duration: bool = true
@export var duration: float = 1.0


func _init():
	hide()


func _start():
	if transition_in:
		transition_in._start(self)
	else:
		show()
	
	_slide()

	if continue_after_duration:
		await get_tree().create_timer(duration).timeout
	else:
		await slide_finished

	if transition_out:
		transition_out._start(self)
	else:
		hide()
	
	emit_signal("finished")


func _slide():
	pass
