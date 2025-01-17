class_name StableHordeModelReference
extends StableHordeHTTPRequest

signal reference_retrieved(models_list)

@export var compvis_refence_url := "https://raw.githubusercontent.com/db0/AI-Horde-image-model-reference/main/stable_diffusion.json"
@export var diffusers_refence_url := "https://raw.githubusercontent.com/db0/AI-Horde-image-model-reference/main/diffusers.json"

var model_reference := {}
var models_retrieved = false

func _ready() -> void:
	# We pick the first reference immediately as we enter the scene
	timeout = 2
	_load_from_file()
	get_model_reference()

func get_model_reference() -> void:
	if state != States.READY:
		push_warning("Model RefCounted currently working. Cannot do more than 1 request at a time with the same Stable Horde Model RefCounted.")
		return
	state = States.WORKING
	var error = request(compvis_refence_url, [], HTTPClient.METHOD_GET)
	if error != OK:
		var error_msg := "Something went wrong when initiating the request"
		push_error(error_msg)
		state = States.READY
		emit_signal("request_failed",error_msg)


# Function to overwrite to process valid return from the horde
func process_request(json_ret) -> void:
	if typeof(json_ret) != TYPE_DICTIONARY:
		var error_msg : String = "Unexpected model reference received"
		push_error("Unexpected model reference received" + ': ' +  json_ret)
		emit_signal("request_failed",error_msg)
		state = States.READY
		return
	model_reference = json_ret
	_store_to_file()
	emit_signal("reference_retrieved", model_reference)
	state = States.READY

func get_model_info(model_name: String) -> Dictionary:
	return(model_reference.get(model_name, {}))

func is_model(model_name: String) -> bool:
	return(model_reference.has(model_name))

func _store_to_file() -> void:
	var file = FileAccess.open("user://model_reference", FileAccess.WRITE)
	file.store_var(model_reference)
	file.close()

func _load_from_file() -> void:
	var file = FileAccess.open("user://model_reference", FileAccess.READ)
	if !file:
		printerr(FileAccess.get_open_error())
		return
	else:
		var filevar = file.get_var()
		if filevar:
			model_reference = filevar
	file.close()
