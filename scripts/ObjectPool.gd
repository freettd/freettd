class_name ObjectPool

var scene: Resource
var pool_size_increment: int

var pool: Array = []
var free_pool: Array = []

func init(scene, init_pool_size: int = 100, pool_size_increment: int = 100) -> void:
	
	self.scene = scene
	self.pool_size_increment = pool_size_increment	
	_increase_pool_size(pool_size_increment)
	
func get_free_object():
	if free_pool.empty():
		_increase_pool_size(pool_size_increment)
		
	return free_pool.pop_back()
	
func set_object_free(object) -> void:
	free_pool.append(object)

func _increase_pool_size(size: int) -> void:
	for i in size:
		free_pool.append(scene.instance())
