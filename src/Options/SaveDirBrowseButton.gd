extends Button

signal savedir_path_set(path)

func _ready():
	pass
	#save_dir_browse_native_dialog_select_folder.initial_path = SettingsManager.config.get_value("Options", "savedir_path", "user://")

func _on_SaveDirBrowseNativeDialogSelectFolder_folder_selected(folder: String):
	SettingsManager.set_setting("savedir_path", folder, "Options")
	#save_dir_browse_native_dialog_select_folder.initial_path = folder + '/'
	emit_signal("savedir_path_set", folder)

func _on_SaveDirBrowseButton_pressed():
	DisplayServer.file_dialog_show(
		"Select Folder",
		SettingsManager.config.get_value("Options", "savedir_path", "user://"),
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_DIR,
		[],
		_on_SaveDirBrowseNativeDialogSelectFolder_folder_selected
	)

