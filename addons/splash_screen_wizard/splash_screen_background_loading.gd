class_name SplashScreenBackgroundLoading extends Node


@export var enabled: bool = true
@export_file var file_path: String


var thread_status: ResourceLoader.ThreadLoadStatus
var thread_progress: Array = []
var thread_result: Variant = null


func _ready() -> void:
    if not enabled:
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
