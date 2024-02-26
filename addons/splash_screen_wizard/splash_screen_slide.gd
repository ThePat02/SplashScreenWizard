@icon("res://addons/splash_screen_wizard/icons/SplashScreenSlide.svg")
class_name SplashScreenSlide extends Control
## A slide in the used and displayed in the [SplashScreen].
##
## Slides are used to display the splash screen's content. They can be used to display a logo, a loading screen, or any other content that should be displayed before the game starts.
## Using [SlideTransition]s, it is possible to animate the slide's entrance and exit.
## [br][br]
## When implementing custom logic for a slide, extend this class,  override the [method _slide] method and emit the [signal slide_finished]
## when the slide is ready for the [member transition_out].
## This can be used to trigger animations, load resources, or perform any other logic that should be executed before the slide is finished.
##
## @tutorial(Creating custom logic for slides): https://github.com/ThePat02/SplashScreenWizard?tab=readme-ov-file#creating-custom-logic-for-slides


## Emitted when [method _slide] is finished and the slide is ready for the [member transition_out].
signal slide_finished
## Emitted when the slide is finished and the [SplashScreen] can continue with the next slide.
signal finished


## The transition used to animate the slide's entrance.
@export var transition_in: SlideTransition
## The transition used to animate the slide's exit.
@export var transition_out: SlideTransition
## If true, the slide will automatically continue after the [member duration] has passed, without waiting for [signal slide_finished].
@export var continue_after_duration: bool = true
## The duration of the slide in seconds.
@export var duration: float = 1.0
## If true, the slide can be skipped by pressing the keys defined by the [member SplashScreen.skip_input_action]
@export var skippable: bool = false


func _init() -> void:
	hide()


func _start() -> void:
	if transition_in:
		await transition_in._start(self)
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


func _skip() -> void:
	if skippable:
		hide()
		process_mode = PROCESS_MODE_DISABLED
		emit_signal("finished")


## Override this method to implement the slide's logic and emit [signal slide_finished] when the slide is ready for the [member transition_out].
func _slide() -> void:
	pass
