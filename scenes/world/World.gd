extends Node

onready var terrain = $Terrain
onready var selector = $Selector

# Navigation Objects
var roadnav: AStar2D = AStar2D.new()

func new_world() -> void:
	
	var map_size: Vector2 = Vector2(128, 128)
	
	# Terrain
	terrain.new_world({
		map_size = map_size
	})
	
	# New world


# LOCAL COMMANDS

# process local commands from UI
func process_local_command(command: Dictionary) -> void:
	
	var opcode: int = command.opcode
	
	if Global.SelectorConfig.has(opcode):
		selector.activate(command, Global.SelectorConfig.get(opcode))
	
# process commands after tiles selected
func _on_Selector_tile_selected(command):
	print(command)
	
	match command.opcode:
		
		Global.OpCode.BUILD_ROAD:
			terrain.build_road(command, roadnav)


func _on_Selector_error(msg):
	prints("error", msg)
