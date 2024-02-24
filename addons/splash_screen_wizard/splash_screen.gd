class_name SplashScreen extends Control


signal next_slide_started(slide: SplashScreenSlide)
signal slide_finished(slide: SplashScreenSlide)


@export var auto_start: bool = true
@export var delay_between_slides: float = 1.0


var slides: Array[SplashScreenSlide] = []


func _ready():
	if auto_start:
		start()


func start():
	_update_slides()
	_start_slides()


func _start_slides():
	for slide: SplashScreenSlide in slides:
		next_slide_started.emit(slide)

		slide._start()

		await slide.finished
		await get_tree().create_timer(delay_between_slides).timeout

		slide.hide()

		slide_finished.emit(slide)


func _update_slides():
	slides.clear()

	for child: SplashScreenSlide in get_children():
		slides.append(child)
