extends "res://scenes/world/LayedTilemap.gd"

signal tile_selected(command)
signal error(msg)	

export (NodePath) var world_terrain
onready var terrain: Node2D = get_node(world_terrain)

# drag values
var drag_enabled: bool = false
var box: Rect2 = Rect2()
var current_tile: Vector2 = Vector2.INF
var selected_tile: Vector2 = Vector2.INF

# command config
var command: Dictionary
var config: Dictionary

var wcfg: Dictionary

var start_tile: Vector2
var end_tile: Vector2

var path_angle: int
var tileset_type: int

enum PathAngle {
	ANGLE_0, 
	ANGLE_45,
	ANGLE_90,
	ANGLE_135
}

func new_world(cfg: Dictionary) -> void:
	self.wcfg = cfg

func activate(command: Dictionary, config: Dictionary) -> void:
	deactivate()
	self.command = command
	self.config = config
	visible = true

func deactivate() -> void:
	reset()
	visible = false
		
func reset() -> void:
	clear()
	path_angle = PathAngle.ANGLE_0

func _unhandled_input(event: InputEvent) -> void:

	# ignore if not visible
	if not visible:
		return

	# user pressed escape
	if Input.is_action_pressed("ui_cancel"):
		drag_enabled = false
		visible = false
		return
		
	# get current cell
	var cellv: Vector2 = terrain.world_to_map(get_global_mouse_position())
	
	if cellv != Vector2.INF:
		current_tile = cellv
		
	# user pressed left mouse button
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		_handle_button_click(event)
		
	# user move mouse
	elif event is InputEventMouseMotion:
		_handle_mouse_move()

func _handle_button_click(event) -> void:
	
	if event.pressed:
				
		if config.mode != Global.SelectMode.FIXED:
			drag_enabled = true
			selected_tile = current_tile
		
	else:
	
		drag_enabled = false
		
		command.selection = {
			start_tile = box.position,
			dimension = box.size
		}
		emit_signal("tile_selected", command)
		
		reset()
			
		if not config.repeat:
			visible = false

func _handle_mouse_move() -> void:

	# clear all squares
	reset()
	
	# use default selection size
	if drag_enabled:
		box = Rect2(selected_tile, current_tile - selected_tile).abs()
		box.size = box.size + Vector2.ONE
	else:
		box = Rect2(current_tile, config.dimension)
		
	# default tile type
	tileset_type = wcfg.tindex.fulltile
	
	# use selection mode
	match config.mode:
		
		Global.SelectMode.FIXED:
			_draw_boxed_area()
			
		Global.SelectMode.DRAG:
			_draw_boxed_area()

		Global.SelectMode.LINE45, Global.SelectMode.LINE90:
			if drag_enabled:
				tileset_type = wcfg.tindex.railtile
				_draw_direct_path()
			else:
				_draw_boxed_area()

				
# draw path with 45 angles
func _draw_direct_path() -> void:

	# draw 90 degree
	if box.size.x != box.size.y:

		# east-west or north-south
		if (box.size.x < box.size.y):
			start_tile = Vector2(selected_tile.x, box.position.y)
			end_tile = Vector2(selected_tile.x, box.end.y - 1)
			path_angle = PathAngle.ANGLE_0
		else:
			start_tile = Vector2(box.position.x, selected_tile.y)
			end_tile = Vector2(box.end.x - 1, selected_tile.y)
			path_angle = PathAngle.ANGLE_90
			
		box = Rect2(start_tile, (end_tile - start_tile) + Vector2.ONE)
		
		_draw_boxed_area()	
	
	# draw 45 angle
	elif config.mode == Global.SelectMode.LINE45:
	
		var increment: int

		# start in top-left and increment each direction by 1
		if current_tile == box.position or selected_tile == box.position:
			start_tile = box.position  # top left
			end_tile = box.end # bottom right
			increment = 1
			path_angle = PathAngle.ANGLE_45
			
		# start in bottom-left and increment x by and y by -1
		else:
			start_tile = Vector2(box.position.x, box.end.y - 1)  # bottom left
			end_tile = Vector2(box.end.x, box.position.y) # top right
			increment = -1
			path_angle = PathAngle.ANGLE_135
			
		# draw lines
		_draw_diaganal_line(start_tile, end_tile, increment)
		#draw_diaganal_line(start_tile + Vector2(1, 0), end_tile + Vector2(0, -1), increment)

	
# draw selection tiles			
func _draw_boxed_area() -> void:
	
	var tileset_idx: int = 0

	if path_angle == PathAngle.ANGLE_0:
		tileset_idx = 0
	elif path_angle == PathAngle.ANGLE_90:
		tileset_idx = 1
	
	for x in range(box.position.x, box.end.x):
		for y in range(box.position.y, box.end.y):
			
			var cellv = Vector2(x, y)
			
			if not terrain.is_valid_tile(cellv):
				continue
			
			# check if allowed on water
			#if not config.on_water and terrain.is_water(cellv):
				#pass
				
			# check is allowed on slope
			#if not config.on_slope and terrain.is_slope(cellv):
				#pass 	
			
			# get cell data
			var tdata: Dictionary = terrain.get_tile_data(cellv)
			
			# draw boxen
			set_cellv_height(cellv, tdata.height)
			set_cellv(cellv, tileset_type + tileset_idx)
		
func _draw_diaganal_line(start, end, increment: int) -> void:

	var tileset_idx: int = 0

	# draw 2 lines
	for i in range(0, 2):
		
		if path_angle == PathAngle.ANGLE_45:
			tileset_idx = 2 + (2 * i)
		elif path_angle == PathAngle.ANGLE_135:
			tileset_idx = 3 + (2 * i)

		var step: int = 0
		
		var s2 = start + Vector2(i, 0)
		var e2 = end + Vector2(0, -i)

		for x in range(s2.x, e2.x):

			var cellv: Vector2 = Vector2(x, s2.y + step)
			
			if not terrain.is_valid_tile(cellv):
				continue
						
			# get cell data
			var tdata: Dictionary = terrain.get_tile_data(cellv)
			
			# draw boxen
			set_cellv_height(cellv, tdata.height)
			set_cellv(cellv, tileset_type + tileset_idx)
			
			step += increment

