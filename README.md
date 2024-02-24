# SplashScreenWizard

<p align="center">
  <img src="addons\splash_screen_wizard\icons\ProjectIcon.png" alt="Logo"/>
</p>

<center>
A simple plugin for the Godot Game Engine that allows you to create a custom splash screen for your game.
</center>

<br>

> [!NOTE]
> This plugin doesn't change the Boot Splash Screen of the Godot Engine that can be customized in the Project Settings. It provieds a new set of `Control` nodes that can be used to create a custom splash screen inside the `SceneTree`.


You can also [buy me a coffee](https://ko-fi.com/pat02) if you like the plugin and feel like supporting me :D

## Installation
You can install the plugin in one of the following ways:

- Use the Godot Asset Library to install the plugin directly from the Godot Editor.
- Get the latest release from the [Releases](https://github.com/ThePat02/SplashScreenWizard/releases) page and add the contents of the `addons` directory to your project.
- Clone the repository using `git clone`.


## Usage
> [!TIP]
> Each node and resource is documented using the Godot Engine's built-in documentation system. You can access the documentation by pressing `F1` or hovering over properties in the editor.

<p align="center">
  <img src="images\screenshot_tree.png" alt="Screenshot of the SceneTree"/>
</p>

The plugin provides the ![IconSplashScreen](addons/splash_screen_wizard/icons/SplashScreen.svg) `SplashScreen`  and ![IconSplashScreenSlide](addons/splash_screen_wizard/icons/SplashScreenSlide.svg) `SplashScreenSlide` nodes. The `SplashScreen` node is the root node of the splash screen and the `SplashScreenSlide` nodes are the slides that are shown on the splash screen in order. You can add as many slides as you want to the `SplashScreen` node and customize them to your liking.


### Quick Start
1. Enable the plugin in the Project Settings.
2. Create a new `SplashScreen` node in your scene.
3. Add `SplashScreenSlide` nodes as children of the `SplashScreen` node.
   - I highly recommend creating a new scene for each slide with the `SplashScreenSlide` as the root node, as it will make it easier to edit the slides.
4. Customize the Slide nodes to your liking.
    - Set transitions (FadeIn, FadeOut, etc.) using the `transition_in` and `transition_out` properties. This plugin comes built-in with `SlideTransitionFade`, but you can create your own by inheriting from `SlideTransition`.
    - If there is no custom logic required, setting `continue_after_duration` to `true` will automatically continue to the next slide after the `duration` has passed.
    - If you want to add custom logic (e.g. animations, confirmation prompts, etc.), set `continue_after_duration` to `false` and extend the `SplashScreenSlide` script.
5. Run the scene and enjoy your custom splash screen.
    - If `autorun` is disabled, you can call `start()` on the `SplashScreen` node to start the splash screen manually.


> [!IMPORTANT]
> Make sure to set the correct `Anchor Presets` for the `SplashScreen` and `SplashScreenSlide` nodes, as they still function as regular `Control` nodes. You can do this by selecting the node and clicking the green circle with the white cross in your toolbar. Most of the time you will want to set the `Anchor Presets` to `Full Rect`.


### Advanced Usage
As mentioned above, all nodes, functions and resources you will ever need are documented. There also is a demo scene included that showcases some of the features of the plugin. You can find it in the `demo_splash_screen_wizard` directory.

#### Creating custom logic for slides
Right click on the `SplashScreenSlide` node and select `Extend Script`. This will create a new script that extends the `SplashScreenSlide` class. You can now override the `_slide()
` method and implement your own logic, like playing animations from the `AnimationPlayer` or showing a confirmation prompt. After your logic is done, emit the `slide_finished` signal to continue to the next slide.

##### Example from the demo scene
```gdscript
func _slide() -> void:
	var animation_player = %AnimationPlayer
	animation_player.play("wiggle")
	await animation_player.animation_finished
	slide_finished.emit()
```

#### Creating custom transitions
Create a new script that extends the `SlideTransition` class. You can now override the `_start()` method and implement your own transition logic. It is recommended to use `Tween`s for this, as they are built-in and easy to use.

##### Example from built-in Fade Transition
```gdscript
class_name SlideTransitionFade extends SlideTransition

# ...

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
```


## Contributing
Feel free to open a pull request or an issue if you have any suggestions or found a bug.


## License
This project is licensed under the [MIT License](LICENSE.md).
