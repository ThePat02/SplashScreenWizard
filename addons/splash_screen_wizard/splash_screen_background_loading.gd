# TODO: Add custom icon
class_name SplashScreenBackgroundLoading extends Node
## TODO: Add a description of the class here.
##
## TODO: Add a explanation of the class here.
##
## @tutorial: TODO: Link relevant README header here.

## When enabled, the node will start loading the resource on _ready. When disabled, [method start_loading] must be called manually.
@export var autostart: bool = true
## The file path to the scene file (.tscn) the ResourceLoader will load.
@export_file("*.tscn") var file_path: String


## The status of the thread loading the resource.
var thread_status: ResourceLoader.ThreadLoadStatus
## The progress of the thread loading the resource from 0 to 1.
var thread_progress: Array = []
## The final loaded resource from the thread.
var thread_result: PackedScene = null


func _ready() -> void:
    if not autostart:
        set_process(false)
        return

    start_loading()



func _process(_delta) -> void:
    _process_thread()


func _process_thread() -> void:
    thread_status = ResourceLoader.load_threaded_get_status(file_path, thread_progress)

    match thread_status:
        ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED :
            push_error(self.name + ": Failed to load resource from " + file_path)
            set_process(false)
        ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
            push_error(self.name + ": Invalid resource from " + file_path)
            set_process(false)
        ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
            thread_result = ResourceLoader.load_threaded_get(file_path)
            set_process(false)
        _:
            pass


## Start loading the resource from the file path. Needs to be called manually if [member autostart] is disabled.
func start_loading() -> void:
    if file_path == "":
        push_error(self.name + ": file_path is empty")
        set_process(false)
        return
    
    if not file_path.ends_with(".tscn"):
        push_error(self.name + ": file_path is not a .tscn file")
        set_process(false)
        return

    ResourceLoader.load_threaded_request(file_path)
    set_process(true)
