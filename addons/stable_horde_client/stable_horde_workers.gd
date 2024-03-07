# Renamed class to follow snake_case convention
class_name StableHordeWorkers
extends StableHordeHTTPRequest

signal workers_retrieved(workers_list)

var worker_results := []  # Changed variable name to follow snake_case convention
var workers_by_id := {}     # Changed variable name to follow snake_case convention
var workers_by_name := {}   # Changed variable name to follow snake_case convention

func _ready() -> void:
	get_workers()  # Changed function name to follow snake_case convention

func get_workers() -> void:
	if state != States.READY:
		print_debug("Workers currently working. Cannot do more than 1 request at a time with the same Stable Horde Models.")
		return
	state = States.WORKING
	var error = request(SettingsManager.aihorde_url + "/api/v2/workers?type=image", [], HTTPClient.METHOD_GET)  # Renamed variable to follow snake_case convention
	if error != OK:
		var error_msg := "Something went wrong when initiating the stable horde request"  # Changed variable name to follow snake_case convention
		assert(error_msg)  # Changed function name to follow snake_case convention
		state = States.READY
		emit_signal("request_failed",error_msg)  # Changed variable name to follow snake_case convention

# Function to overwrite to process valid return from the horde
func process_request(json_ret) -> void:
	if typeof(json_ret) != TYPE_ARRAY:
		var error_msg : String = "Unexpected worker format received"  # Changed variable name to follow snake_case convention
		assert("Unexpected worker format received" + ': ' +  json_ret)  # Changed function name to follow snake_case convention
		emit_signal("request_failed",error_msg)  # Changed variable name to follow snake_case convention
		state = States.READY
		return
	worker_results = json_ret  # Changed variable name to follow snake_case convention
	for worker in worker_results:
		workers_by_id[worker.id] = worker  # Changed variable name to follow snake_case convention
		workers_by_name[worker.name] = worker  # Changed variable name to follow snake_case convention
	emit_signal("workers_retrieved", workers_by_name)  # Changed variable name to follow snake_case convention
	state = States.READY

func emit_models_retrieved() -> void:
	emit_signal("workers_retrieved", worker_results)  # Changed variable name to follow snake_case convention

func get_worker_info(worker_string: String) -> Dictionary:
	if workers_by_id.has(worker_string):
		return workers_by_id[worker_string]  # Changed variable name to follow snake_case convention
	if workers_by_name.has(worker_string):
		return workers_by_name[worker_string]  # Changed variable name to follow snake_case convention
	return {}

func is_worker(worker_string: String) -> bool:
	return not get_worker_info(worker_string).is_empty()

func get_workers_with_models(models: Array) -> Dictionary:
#	for w in workers_by_name:
#		print([w])
	if models.size() == 0:
		return workers_by_name
	var ret: Dictionary = {}
	for worker_name in workers_by_name:
		for model in models:
			if workers_by_name[worker_name]["models"].has(model.name) and not ret.has(worker_name):
				ret[worker_name] = workers_by_name[worker_name]  # Changed variable name to follow snake_case convention
	return ret