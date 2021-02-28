extends Node

export var max_height: int = 8

onready var terrain = $Terrain
onready var selector = $Selector

func new_world(pckfile) -> void:
	
	var map_size: Vector2 = Vector2(32, 32)
	var tilemap_cfg = pckfile.tilemap
	
	var world_cfg: Dictionary = {
		tilemap_cfg = tilemap_cfg,
		map_size = map_size
	}
	
	# Init terrain
	terrain.set_tileset(load(tilemap_cfg.terrain.src))
	terrain.new_world(world_cfg, tilemap_cfg.terrain)

	# Init selector
	selector.set_tileset(load(tilemap_cfg.selector.src))
	selector.new_world(world_cfg)
	

func process_local_command(command: Dictionary) -> void:
	
	var opcode: int = command.opcode
	
	if Global.SelectorConfig.has(opcode):
		selector.activate(command, Global.SelectorConfig.get(opcode))
	
