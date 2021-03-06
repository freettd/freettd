extends Node

export var max_height: int = 8

onready var terrain = $Terrain
onready var selector = $Selector

func new_world(pckfile) -> void:
	
	var map_size: Vector2 = Vector2(128, 128)
	var tilemap_cfg = pckfile.tilemap
	
	# Terrain
	terrain.set_tileset(load(tilemap_cfg.terrain.src))
	terrain.new_world({
		tindex = tilemap_cfg.terrain.tindex,
		map_size = map_size
	})
	
	# Selector
	selector.set_tileset(load(tilemap_cfg.selector.src))
	selector.new_world({
		tindex = tilemap_cfg.selector.tindex
	})
	
	# New world

	

func process_local_command(command: Dictionary) -> void:
	
	var opcode: int = command.opcode
	
	if Global.SelectorConfig.has(opcode):
		selector.activate(command, Global.SelectorConfig.get(opcode))
	
func _on_Selector_tile_selected(command):
	print(command)