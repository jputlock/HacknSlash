# Author: Brett Ludwig
# 
# Handles Pathing for an entity, should be made on a per entity basis if higher accuracy is desired
# If you don't care about the most perfectly optimal pathing and want to save some memory
# Have one pather in the root node that has a node size equal to your largest entity
# 
# IMPORTANT!!!!!!!
# For an object to be considered an obstruction by pathing it must be added to the obstruction group

extends AStar

var node
var nodeHeight
var nodeWidth
var numOfNodes = 0

func _init(nodeWidth, nodeHeight, node):
	self.node = node;
	print(self.node)
	
	#get's the smallest node's that can tesellate viewport properly that also fit collision box
	self.nodeHeight = nodeHeight
	while int(self.node.get_viewport().get_rect().size.y) % self.nodeHeight != 0:
		self.nodeHeight += 1
	self.nodeWidth = nodeWidth
	while int(self.node.get_viewport().get_rect().size.x) % self.nodeWidth != 0:
		self.nodeWidth += 1
	createNodeMap()

#adds nodes to A* in a flattened array format, row major
func createNodeMap():
	for i in range(self.numOfNodes):
		self.remove_point(i)
	#var y = self.node.get_viewport().get_rect().size.y / self.nodeHeight;
	#var x = self.node.get_viewport().get_rect().size.x / self.nodeWidth;
		var currentPoint = 0;
	var obstacles = self.node.get_tree().get_nodes_in_group("obstruction")
	var floorTileMap = self.node.get_tree().get_root().get_node("Game/World/Floor")
	var floorStuff = floorTileMap.get_used_cells()
	for i in range(floorStuff.size()):
		print(floorTileMap.map_to_world(floorStuff[i], true))
		print(floorStuff[i])
	var obstacleTileMap = self.node.get_tree().get_root().get_node("Game/World/Walls")
	var environmentRaw = obstacleTileMap.get_used_cells()
	for i in range(environmentRaw.size()):
		if obstacleTileMap.get_cellv(environmentRaw[i]) != 0:
			#self.add_point(
			pass

	#for yOffset in range(y):
	#	for xOffset in range(x):
	#		pass
			#self.add_point(currentPoint++, Vector3((self.nodeWidth/2) + xOffset * self.nodeWidth, (self.nodeHeight/2) + yOffset * self.nodeHeight, 1), )
	
	
		
func get_path(goalVector):
	
	pass