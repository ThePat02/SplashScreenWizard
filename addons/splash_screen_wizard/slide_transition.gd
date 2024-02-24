@icon("res://addons/splash_screen_wizard/icons/SlideTransition.svg")
class_name SlideTransition extends Resource
## Base class for all transitions used by [SplashScreenSlide]s.
##
## Transitions can be slotted into [member SplashScreenSlide.transition_in] and [member SplashScreenSlide.transition_out] to control how the slide appears
## and disappears respectively.
## [br][br]
## To create a custom transition, inherit from this class and override the [method _start] method. It is recommended to use
## a [Tween] to animate the transition. Take a look at the code of the [SlideTransitionFade] class for an example.
##
## @tutorial(Creating custom transitions): https://github.com/ThePat02/SplashScreenWizard?tab=readme-ov-file#creating-custom-transitions


## Override this method to implement the transition logic. For example: [SlideTransitionFade]
func _start(target: Node) -> void:
    pass
