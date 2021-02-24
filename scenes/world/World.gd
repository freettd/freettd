extends Node

onready var terrain = $Terrain

func new_world(pckfile) -> void:
	terrain.new_terrain(pckfile.terrain)
