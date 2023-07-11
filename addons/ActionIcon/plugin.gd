@tool
extends EditorPlugin


func _enter_tree():
	var base_path := (get_script() as Script).resource_path.get_base_dir()
	add_autoload_singleton("__action_texture_picker", base_path.path_join("action_texture_picker.gd"))


func _exit_tree():
	remove_autoload_singleton("__action_texture_picker")
