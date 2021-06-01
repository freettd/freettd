class_name Resources

const tilemaps = {
	road = {
		cost = 10000
	}
}

const buildings = {
	company_hq = {
		cost = 1000000,
		src = "res://resources/hq/CompanyHQ.tscn"
	},
	road_depot = {
		cost = 1000,
		src = "res://resources/depot/RoadDepot.tscn"
	}
}

const trees = {
	cost = 10,
	src = {
		temperate = [
			"res://resources/trees/temperate/TempTree1.tscn",
			"res://resources/trees/temperate/TempTree2.tscn",
			"res://resources/trees/temperate/TempTree3.tscn",
			"res://resources/trees/temperate/TempTree4.tscn",
			"res://resources/trees/temperate/TempTree5.tscn",
			"res://resources/trees/temperate/TempTree6.tscn",
			"res://resources/trees/temperate/TempTree7.tscn",
			"res://resources/trees/temperate/TempTree8.tscn",
		]
	}
}

const vehicles = {
	modern_bus = {
		src = "res://resources/roadvehicles/modern/Bus.tscn",
		cost = 1000,
		max_speed = 50,
		tags = ["vehicle", "road_vehicle", "bus"],
		capacity = {
			pax = 25
		}
	}
}
