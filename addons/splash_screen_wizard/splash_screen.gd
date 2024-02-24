@icon("res://addons/splash_screen_wizard/icons/SplashScreen.svg")
class_name SplashScreen extends Control
## A splash screen, which can be used to display several [SplashScreenSlide]s in a sequence.
##
## This is the main node of the `SplashScreenWizard` plugin and should be used as the root node of your splash screen.
## Add [SplashScreenSlide] nodes as children to display them in a sequence. The slides will hide automatically when running, so you don't have to hide them manually in the editor.
## Other nodes (e.g. a background or a logo) can be added as children as well,
## but they will not be affected by the splash screen and will be displayed at the same time as the slides.
##
## @tutorial(GitHub ReadMe): https://github.com/ThePat02/SplashScreenWizard


## Emitted when a new slide is started.
signal next_slide_started(slide: SplashScreenSlide)
## Emitted when a slide is finished.
signal slide_finished(slide: SplashScreenSlide)
## Emitted when all slides are finished and the cleanup is done.
signal finished


## If `true`, the splash screen will start automatically when it is ready. If `false`, you have to call [method start] manually.
@export var auto_start: bool = true
## The delay between the slides in seconds.
@export var delay_between_slides: float = 1.0
## If `true`, the splash screen will be deleted after it is finished using [method Node.queue_free].
@export var delete_after_finished: bool = true


## A list of all slides in the splash screen. This is automatically updated when the splash screen is started.
var slides: Array[SplashScreenSlide] = []


func _ready() -> void:
	if auto_start:
		start()


## Starts the splash screen. This will update the slides, start them and clean up afterwards. Called automatically if [member auto_start] is `true`.
func start() -> void:
	_update_slides()
	await _start_slides()
	_cleanup()
	finished.emit()


func _update_slides() -> void:
	slides.clear()

	for child in get_children():
		if child is SplashScreenSlide:
			slides.append(child)


func _start_slides() -> void:
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
