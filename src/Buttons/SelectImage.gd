extends Button

signal image_selected(filename)

@onready var select_image_native_dialog_open_file = "res://addons/native_dialogs/native_dialogs.gd"

func _on_SelectImageNativeDialogOpenFile_files_selected(files: Array):
	if files.size() == 0:
		return
	var filename: String = files[0]
	globals.set_setting("source_image_initial_path", filename.get_base_dir() + '/', "Options")
	select_image_native_dialog_open_file.initial_path = filename.get_base_dir() + '/'
	emit_signal("image_selected", filename)

func _on_SelectImage_pressed():
	DisplayServer.file_dialog_show("Select an image", "user://", "", false, DisplayServer.FILE_DIALOG_MODE_OPEN_FILES, ["jpeg", "png"], _on_SelectImageNativeDialogOpenFile_files_selected)
