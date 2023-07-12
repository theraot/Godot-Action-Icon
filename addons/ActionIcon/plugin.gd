@tool
extends EditorPlugin


const autoload_name := "__action_texture_picker"


static var base_path := (preload("plugin.gd") as Script).resource_path.get_base_dir()


func _enter_tree():
	await get_tree().process_frame
	if not is_instance_valid(get_tree().root.get_node_or_null(autoload_name)):
		add_autoload_singleton("__action_texture_picker", base_path.path_join("action_texture_picker.gd"))


func _exit_tree():
	remove_autoload_singleton("__action_texture_picker")
