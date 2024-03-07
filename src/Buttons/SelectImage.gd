extends Button

signal image_selected(filename)


func _ready():
	pass
	#select_image_native_dialog_open_file.initial_path = SettingsManager.config.get_value("Options", "source_image_initial_path", "user://")

func _on_SelectImageNativeDialogOpenFile_files_selected(files: Array):
	if files.size() == 0:
		return
	var filename: String = files[0]
	SettingsManager.set_setting("source_image_initial_path", filename.get_base_dir() + '/', "Options")
	#select_image_native_dialog_open_file.initial_path = filename.get_base_dir() + '/'
	emit_signal("image_selected", filename)

func _on_SelectImage_pressed():
	DisplayServer.file_dialog_show(
		"Select Image",
		SettingsManager.config.get_value("Options", "source_image_initial_path", "user://"),
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
		["*.png", "*.jpg", "*.jpeg"],
		_on_SelectImageNativeDialogOpenFile_files_selected
	)
