extends MarginContainer

@onready var remember_prompt = $"%RememberPrompt"
@onready var larger_values = $"%LargerValues"
@onready var shared = $"%Shared"
@onready var save_dir = $"%SaveDir"
@onready var save_dir_browse_button = $"%SaveDirBrowseButton"
@onready var api_key := $"%APIKey"
@onready var api_key_label := $"%APIKeyLabel"
@onready var login_button = $"%LoginButton"
@onready var stable_horde_login = $"%StableHordeLogin"
@onready var load_seed_from_disk = $"%LoadSeedFromDisk"
@onready var wipe_cache = $"%WipeCache"

func _ready():
	remember_prompt.button_pressed = SettingsManager.get_setting("remember_prompt")
	remember_prompt.connect("toggled", Callable(self, "_on_remember_prompt_pressed"))
	#larger_values.button_pressed = SettingsManager.get_setting("larger_values")
	larger_values.connect("toggled", Callable(self, "_on_larger_values_pressed"))
	load_seed_from_disk.button_pressed = SettingsManager.get_setting("seed")
	load_seed_from_disk.connect("toggled", Callable(self, "_on_load_seed_from_disk_pressed"))
	#shared.button_pressed = SettingsManager.get_setting("shared")
	shared.connect("toggled", Callable(self, "_on_shared_pressed"))

	login_button.connect("pressed", Callable(self, "_on_login_pressed"))
	wipe_cache.connect("pressed", Callable(self, "_on_wipe_cache_pressed"))
	EventBus.connect("generation_completed", Callable(self, "_on_generation_completed"))
#	save_dir.connect("text_changed",self,"_on_savedir_changed")

	save_dir_browse_button.connect("savedir_path_set", Callable(self, "_on_savedir_selected"))
	stable_horde_login.connect("login_successful", Callable(self, "_on_login_succesful"))
	stable_horde_login.connect("request_failed", Callable(self, "_on_login_failed"))
	var default_save_dir = SettingsManager.get_setting("default_save_dir")
	if default_save_dir in ["user://", '']:
		_set_default_savedir_path()
	else:
		save_dir.text = default_save_dir
		_set_default_savedir_path(true)

func set_api_key(new_api_key) -> void:
	api_key.text = new_api_key
	_on_APIKey_text_changed(new_api_key)


func get_api_key() -> String:
	return(api_key.text)

func login() -> void:
	_on_login_pressed()

func _on_remember_prompt_pressed(pressed: bool) -> void:
	SettingsManager.set_setting("remember_prompt", pressed, "Options")

func _on_larger_values_pressed(pressed: bool) -> void:
	SettingsManager.set_setting("larger_values", pressed, "Options")

func _on_load_seed_from_disk_pressed(pressed: bool) -> void:
	SettingsManager.set_setting("load_seed_from_disk", pressed, "Options")

func _on_shared_pressed(pressed: bool) -> void:
	SettingsManager.set_setting("shared", pressed, "Options")
	EventBus.emit_signal("shared_toggled")


func _on_savedir_changed(path: String) -> void:
	match path:
		'%APPDATA%\\Godot\\app_userdata\\Lucid Creations\\':
			SettingsManager.set_setting('default_save_dir', "user://", "Options")
		'${HOME}/.local/share/godot/app_userdata/Lucid Creations/':
			SettingsManager.set_setting('default_save_dir', "user://", "Options")
		'~/Library/Application Support/Godot/app_userdata/Lucid Creations/':
			SettingsManager.set_setting('default_save_dir', "user://", "Options")
		'':
			_set_default_savedir_path()
		_:
			SettingsManager.set_setting('default_save_dir', path, "Options")


func _set_default_savedir_path(only_placholder = false) -> void:
	match OS.get_name():
		"Windows":
			if not only_placholder:
				save_dir.text = '%APPDATA%\\Godot\\app_userdata\\Lucid Creations\\'
			save_dir.placeholder_text = '%APPDATA%\\Godot\\app_userdata\\Lucid Creations\\'
		"X11":
			if not only_placholder:
				save_dir.text = '${HOME}/.local/share/godot/app_userdata/Lucid Creations/'
			save_dir.placeholder_text = '${HOME}/.local/share/godot/app_userdata/Lucid Creations/'
			
		_:
			if not only_placholder:
				save_dir.text = '~/Library/Application Support/Godot/app_userdata/Lucid Creations/'
			save_dir.placeholder_text = '~/Library/Application Support/Godot/app_userdata/Lucid Creations/'

func _on_savedir_selected(path: String) -> void:
	SettingsManager.set_setting("default_save_dir", path, "Options")
	save_dir.text = path

	
func _on_APIKeyLabel_meta_clicked(meta):
	match meta:
		"register":
		
			OS.shell_open("https://aihorde.net/register")
		"anonymous":
			api_key.text = "0000000000"
			_on_APIKey_text_changed('')
			_on_login_pressed()


func _on_APIKey_text_changed(_new_text):
	if api_key.text == "0000000000":
		api_key_label.text = "API Key = Anonymous [url=register](Register)[/url]"
	else:
		api_key_label.text = "API Key [url=anonymous](Anonymize?)[/url]"

func _on_login_pressed() -> void:
	SettingsManager.set_setting("api_key", api_key.text)
	stable_horde_login.api_key = api_key.text
	stable_horde_login.login()
	$"%LoggedInDetails".visible = false
	api_key.modulate = Color(1,1,0)

func _on_wipe_cache_pressed() -> void:
	EventBus.emit_signal("cache_wipe_requested")

func _on_login_succesful(_user_data) -> void:
	$"%LoggedInDetails".visible = true
	$"%LoggedInUsername".text = "Username: " + stable_horde_login.get_username()
	$"%LoggedInKudos".text = "Kudos: " + str(stable_horde_login.get_kudos())
	$"%LoggedInWorkers".text = "Workers: " + str(stable_horde_login.get_worker_count())
	api_key.modulate = Color(1,1,1)
	SettingsManager.user_kudos = stable_horde_login.get_kudos()

func _on_login_failed(_error_msg) -> void:
	$"%LoggedInDetails".visible = false
	api_key.modulate = Color(1,0,0)

func _on_generation_completed() -> void:
	stable_horde_login.login()
