
extends Node

signal node_hovered(control)
signal node_unhovered(control)
signal rtl_meta_hovered(rt_label, string_id)
signal rtl_meta_unhovered(rt_label)

signal height_changed(hslider)
signal width_changed(hslider)
signal shared_toggled()
signal lora_selected(lora_details)
signal model_selected(model_details)
signal worker_selected(worker_details)
signal kudos_calculated(kudos)
signal generation_completed

signal cache_wipe_requested

func _on_node_hovered(node: Control):
	emit_signal("node_hovered", node)

func _on_node_unhovered(node: Control):
	emit_signal("node_unhovered", node)