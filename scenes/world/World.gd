extends Node

signal hq_selected(company)
signal error(msg)

onready var terrain = $Terrain
onready var selector = $Selector
onready var world_objects = $WorldObjects

# Navigation Objects
var roadnav: AStar2D = AStar2D.new()

# Company Register
var local_company: Company
var company_register: Array = []

func new_world() -> void:
	
	var map_size: Vector2 = Vector2(128, 128)
	
	# Terrain
	terrain.new_world({
		map_size = map_size
	})
	
	# New Company
	local_company = Company.new()
	company_register.append(local_company)


# LOCAL COMMANDS

# process local commands from UI
func process_local_command(command: Dictionary) -> void:
	
	# local command is for local company
	command.company = local_company
	
	var opcode: int = command.opcode
	
	if Global.SelectorConfig.has(opcode):
		selector.activate(command, Global.SelectorConfig.get(opcode))
	
# process commands after tiles selected
func _on_Selector_tile_selected(command):
	
	match command.opcode:
		
		Global.OpCode.BUILD_ROAD:
			terrain.build_road(command, roadnav)
		
		Global.OpCode.BUILD_COMPANY_HQ:
			world_objects.add_hq(Resources.buildings.company_hq_large, command.selection.position, local_company)
			


func _on_Selector_error(msg):
	emit_signal("error", msg)


func _on_WorldObjects_hq_selected(company: Company):
	emit_signal("hq_selected", company)
