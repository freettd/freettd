class_name Command

const GROUP_TREE: String = "GROUP_TREE"

enum ID {

	START_APP,

	NEW_GAME,
	NEW_SCENARIO,

	LOAD_GAME,
	SAVE_GAME,

	EXIT_APP,
	EXIT_GAME,


	TILE_QUERY,

	BUILD_ROAD,
	BUILD_RAIL,
	BUILD_WORLD_OBJECT,

	BUILD_COMPANY_HQ,

	CLEAR_LAND,
	PLANT_TREE,

	CONFIG_TRANSPARENT_TREES

}

const ConfigCommands: Array = [ ID.CONFIG_TRANSPARENT_TREES ]

enum SelectMode {

	# object placement
	FIXED,

	# land area selection
	DRAG,

	# rail
	LINE45,

	# road, canal
	LINE90,

}

const Config: Dictionary = {

	ID.TILE_QUERY: {
		selector = {
			dimension = Vector2.ONE,
			mode = SelectMode.FIXED,
			repeat = true,
			on_water = true,
			on_slope = true,
		}
	},

	ID.BUILD_ROAD: {
		selector = {
			dimension = Vector2.ONE,
			mode = SelectMode.LINE90,
			repeat = true,
			on_water = false,
			on_slope = true,
		}
	},

	ID.BUILD_RAIL: {
		selector = {
			dimension = Vector2.ONE,
			mode = SelectMode.LINE45,
			repeat = true,
			on_water = false,
			on_slope = true,
		}
	},

	ID.BUILD_COMPANY_HQ: {
		selector = {
			dimension = Vector2(2, 2),
			mode = SelectMode.FIXED,
			repeat = false,
			on_water = false,
			on_slope = false,
		}
	},

	ID.CLEAR_LAND: {
		selector = {
			dimension = Vector2.ONE,
			mode = SelectMode.DRAG,
			repeat = true,
			on_water = true,
			on_slope = true,
		}
	},

	ID.PLANT_TREE: {
		selector = {
			dimension = Vector2.ONE,
			mode = SelectMode.DRAG,
			repeat = true,
			on_water = false,
			on_slope = true,
		}
	}

}
