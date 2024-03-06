extends Button

signal gensettings_loaded(settings)

@onready var load_from_disk_native_dialog_open_file = $"%LoadFromDiskNativeDialogOpenFile"

func _ready():
	pass
	#load_from_disk_native_dialog_open_file.initial_path = globals.config.get_value("Options", "load_initial_path", "user://")

func _on_LoadFromDiskNativeDialogOpenFile_files_selected(files: Array):
	if files.size() == 0:
		return
	var filename: String = files[0]
	var file = null
	if filename.ends_with(".png"):
		filename = filename.get_basename() + '.json'
		if not file.file_exists(filename):
			return
	globals.set_setting("load_initial_path", filename.get_base_dir() + '/', "Options")
	#load_from_disk_native_dialog_open_file.initial_path = filename.get_base_dir() + '/'
	file.open(filename, FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var data = test_json_conv.get_data()
	file.close()
	emit_signal("gensettings_loaded", data.result)

func _on_LoadFromDisk_pressed():
	DisplayServer.file_dialog_show(
		"Load Settings",
		globals.config.get_value("Options", "load_initial_path", "user://"),
		"",
		false,
		DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
		["*.json"],
		_on_LoadFromDiskNativeDialogOpenFile_files_selected
	)
