extends Button

signal gensettings_loaded(settings)



func _ready():
	pass
	#load_from_disk_native_dialog_open_file.initial_path = SettingsManager.config.get_value("Options", "load_initial_path", "user://")

func _on_load_from_disk_native_dialog_open_file_files_selected(selectedFiles: Array):
	if selectedFiles.size() == 0:
		return
	var filename: String = selectedFiles[0]
	if filename.ends_with(".png"):
		filename = filename.get_basename() + '.json'
		if not FileAccess.file_exists(filename):
			return
	SettingsManager.set_setting("load_initial_path", filename.get_base_dir() + '/', "Options")
	var file = FileAccess.open(filename, FileAccess.READ)
	var jsonParser = JSON.new()
	jsonParser.parse(file.get_as_text())
	var data = jsonParser.get_data()
	file.close()
	emit_signal("gensettings_loaded", data.result)

# func _on_LoadFromDisk_pressed():
# 	DisplayServer.file_dialog_show(
# 		"Load Settings",
# 		SettingsManager.config.get_value("Options", "load_initial_path", "user://"),
# 		"",
# 		false,
# 		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
# 		["*.json"],
# 		_on_load_from_disk_native_dialog_open_file_files_selected
# 	)

func _on_load_from_disk_pressed():
	DisplayServer.file_dialog_show(
		"Load Settings",
		SettingsManager.get_setting("default_save_dir", "user://"),
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
		["*.json"],
		_on_load_from_disk_native_dialog_open_file_files_selected
	)
