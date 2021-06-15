extends Node2D

signal selected()

onready var wobj_label = $Panel/LinkButton

func _on_LinkButton_pressed():
	emit_signal("selected")

