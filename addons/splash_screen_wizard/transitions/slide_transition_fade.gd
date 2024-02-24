class_name SlideTransitionFade extends SlideTransition


enum FadeType
{
    FADE_IN,
    FADE_OUT,
}

@export var fade_type: FadeType = FadeType.FADE_IN
@export var duration: float = 0.5
@export var transition_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR


func _start(target: Node) -> void:
    var fade: Tween = target.get_tree().create_tween()

    var value_start: float
    var value_end: float

    match fade_type:
        FadeType.FADE_IN:
            value_start = 0
            value_end = 1
        FadeType.FADE_OUT:
            value_start = 1
            value_end = 0

    
    target.modulate.a = value_start
    target.show()
    fade.tween_property(target, "modulate:a", value_end, duration).set_trans(transition_type)

    await fade.finished