extends EditorInspectorPlugin


const BUTTON_NEW_SLIDE: String = "Add new Slide"
const BUTTON_NEW_BACKGROUND_LOADING: String = "Add new Background Loading"


var icon_add_slide = load("res://addons/splash_screen_wizard/icons/IconAddSlide.svg")


func _can_handle(object):
	if object is SplashScreen:
		return true
	else:
		return false


func _parse_category(object, category):
	if category == "splash_screen.gd":
		_create_button_new_slide(object)
		_create_button_new_background_loading(object)


func _create_button_new_slide(object):
	var button_add_slide = Button.new()
	button_add_slide.text = BUTTON_NEW_SLIDE

	button_add_slide.icon = icon_add_slide
	button_add_slide.expand_icon = true
	button_add_slide.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button_add_slide.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP

	button_add_slide.connect("pressed", _on_button_add_slide_pressed.bind(object))

	add_custom_control(button_add_slide)


func _create_button_new_background_loading(object):
	var button_background_loading = Button.new()
	button_background_loading.text = BUTTON_NEW_BACKGROUND_LOADING

	button_background_loading.connect("pressed", _on_button_add_background_loading_pressed.bind(object))

	add_custom_control(button_background_loading)


func _on_button_add_slide_pressed(object: SplashScreen):
	var new_slide = SplashScreenSlide.new()
	new_slide.name = "NewSlide"
	new_slide.visible = true

	object.add_child(new_slide)
	new_slide.set_owner(object.get_tree().edited_scene_root)


func _on_button_add_background_loading_pressed(object: SplashScreen):
	var new_background_loading = SplashScreenBackgroundLoading.new()
	new_background_loading.name = "NewBackgroundLoading"

	object.add_child(new_background_loading)
	new_background_loading.set_owner(object.get_tree().edited_scene_root)
