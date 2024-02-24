class_name SplashScreen extends Control


signal next_slide_started(slide: SplashScreenSlide)
signal slide_finished(slide: SplashScreenSlide)


@export var auto_start: bool = true
@export var delay_between_slides: float = 1.0
@export var delete_after_finished: bool = true


var slides: Array[SplashScreenSlide] = []


func _ready():
	if auto_start:
		start()


func start():
	_update_slides()
	await _start_slides()
	_cleanup()


func _update_slides():
	slides.clear()

	for child in get_children():
		if child is SplashScreenSlide:
			slides.append(child)


func _start_slides():
	for slide: SplashScreenSlide in slides:
		next_slide_started.emit(slide)

		slide._start()

		await slide.finished
		await get_tree().create_timer(delay_between_slides).timeout

		slide.hide()

		slide_finished.emit(slide)


func _cleanup() -> void:
	if delete_after_finished:
		queue_free()
