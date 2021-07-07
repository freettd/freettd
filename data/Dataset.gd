class_name Dataset

enum TransportType {
	ROAD,
	SEA
}

const tilemaps = {
	road = {
		cost = 10000
	}
}

const buildings = {
	company_hq = {
		cost = 1000000,
		src = "res://data/hq/CompanyHQ.tscn"
	},
	road_depot = {
		cost = 1000,
		src = "res://data/depot/RoadDepot.tscn"
	}
}

const trees = {
	cost = 10,
	src = {
		temperate = [
			"res://data/trees/temperate/TempTree1.tscn",
			"res://data/trees/temperate/TempTree2.tscn",
			"res://data/trees/temperate/TempTree3.tscn",
			"res://data/trees/temperate/TempTree4.tscn",
			"res://data/trees/temperate/TempTree5.tscn",
			"res://data/trees/temperate/TempTree6.tscn",
			"res://data/trees/temperate/TempTree7.tscn",
			"res://data/trees/temperate/TempTree8.tscn",
		]
	}
}

const vehicles = {
	modern_bus = {
		src = "res://data/roadvehicles/modern/ModernBus.tscn",
		profile_img = "res://assets/road/vehicles/bus/128_0008.png",
		transport_type = TransportType.ROAD,
		cost = 1000,
		max_speed = 50,
		name = "Bus One",
		tags = ["vehicle", "road_vehicle", "bus"],
		capacity = {
			pax = 25
		}
	},
	modern_mailvan = {
		name = "Mail One",
		transport_type = TransportType.ROAD
	},
	hovercraft = {
		name = "hovercraft",
		transport_type = TransportType.SEA,
	}
}
	

