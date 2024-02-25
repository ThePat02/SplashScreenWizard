@icon("res://addons/splash_screen_wizard/icons/SplashScreen.svg")
class_name SplashScreen extends Control
## A splash screen, which can be used to display several [SplashScreenSlide]s in a sequence.
##
## This is the main node of the `SplashScreenWizard` plugin and should be used as the root node of your splash screen.
## Add [SplashScreenSlide] nodes as children to display them in a sequence. The slides will hide automatically when running, so you don't have to hide them manually in the editor.
## Other nodes (e.g. a background or a logo) can be added as children as well,
## but they will not be affected by the splash screen and will be displayed at the same time as the slides.
##
## @tutorial(QuickStart Guide): https://github.com/ThePat02/SplashScreenWizard?tab=readme-ov-file#quick-start


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
## The input action that can be used to skip a [SplashScreenSlide], if [member SplashScreenSlide.skippable] is `true`.
@export var skip_input_action: StringName
## If `true`, the splash screen will be deleted after it is finished using [method Node.queue_free].
@export var delete_after_finished: bool = true


## A list of all slides in the splash screen. This is automatically updated when the splash screen is started.
var slides: Array[SplashScreenSlide] = []
## The current slide that is being displayed.
var current_slide: SplashScreenSlide


var _delay_timer: Timer


func _ready() -> void:
	if not InputMap.has_action(skip_input_action):
		push_warning("SplashScreen: The input action \"" + skip_input_action + "\" does not exist in the Input Map.")

	if auto_start:
		start()


func _input(event):
	if not current_slide:
		return
	
	if skip_input_action == "":
		return

	if event.is_action_pressed(skip_input_action):
		_skip_slide()
	

## Starts the splash screen. This will update the slides, start them and clean up afterwards. Called automatically if [member auto_start] is `true`.
func start() -> void:
	_configure_timer()
	_update_slides()
	await _start_slides()
	_cleanup()
	finished.emit()


func _configure_timer() -> void:
	_delay_timer = Timer.new()
	_delay_timer.one_shot = true
	add_child(_delay_timer)


func _update_slides() -> void:
	slides.clear()

	for child in get_children():
		if child is SplashScreenSlide:
			slides.append(child)
	
	if slides.size() == 0:
		push_warning("SplashScreen: No slides found. Add some SplashScreenSlide nodes as children to display them in a sequence.")


func _start_slides() -> void:
	for slide: SplashScreenSlide in slides:
		current_slide = slide
		next_slide_started.emit(slide)

		current_slide._start()

		await current_slide.finished

		_delay_timer.start(delay_between_slides)
		await _delay_timer.timeout

		slide_finished.emit(current_slide)


func _cleanup() -> void:
	_delay_timer.queue_free()
	if delete_after_finished:
		queue_free()


func _skip_slide() -> void:
	if current_slide:
		current_slide._skip()
		_delay_timer.stop()
		_delay_timer.emit_signal("timeout")
