extends Node

signal hq_selected(company)
signal local_company_updated(company)
signal error(msg)

# World components
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
func _on_Selector_tile_selected(command: Dictionary):
	
	var tm_resources = Resources.tilemaps
	var bld_resources = Resources.buildings
	var dimension = command.selection.dimension
	
	match command.opcode:
		
		Global.OpCode.BUILD_ROAD:
			var cost: int = tm_resources.road.cost * (dimension.x * dimension.y)
			local_company.add_expense(cost)
			terrain.build_road(command, roadnav)
		
		Global.OpCode.BUILD_COMPANY_HQ:
			var cost: int = bld_resources.company_hq_large.cost
			local_company.add_expense(cost)
			world_objects.add_hq(Resources.buildings.company_hq_large, command.selection.position, local_company)
			
	
			
	emit_signal("local_company_updated", local_company)


func _on_Selector_error(msg):
	emit_signal("error", msg)


func _on_WorldObjects_hq_selected(company: Company):
	if not selector.visible:
		emit_signal("hq_selected", company)
