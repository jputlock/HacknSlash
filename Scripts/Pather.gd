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
	while int(self.node.get_viewport().get_rect().size.y) % int(self.nodeHeight) != 0:
		self.nodeHeight += 1
	self.nodeWidth = nodeWidth
	while int(self.node.get_viewport().get_rect().size.x) % int(self.nodeWidth) != 0:
		self.nodeWidth += 1
	createNodeMap()

#Creates a Dictionary of the map ***Should only be called on creation as the map isn't gonna randomly change, only entity positions will
#which is find since that's is handled when the path is requested
var map = {}
func createNodeMap():
	print("PATHING: A* setup")
	var currentPoint = 0;
 	#creating the available nodes
	var floorTileMap = self.node.get_tree().get_root().get_node("Game/World/Floor")
	floorTileMap.set_half_offset(16)
	var floorStuff = floorTileMap.get_used_cells()
	for i in range(floorStuff.size()):
		self.map[floorStuff[i]] = true
	
	#creating the unavailable nodes
	var obstacleTileMap = self.node.get_tree().get_root().get_node("Game/World/Walls")
	var environment = obstacleTileMap.get_used_cells()
	for i in range(environment.size()):
		self.map[environment[i]] = false
		
	#move dict information into the A*
	var nodes = map.keys()
	var mapCoordIdDict = {}

	for i in range(nodes.size()):
		var translatedCoord = floorTileMap.map_to_world(nodes[i], true)
		if map[nodes[i]]:
			#normally added if it's an open space
			self.add_point(currentPoint, Vector3(translatedCoord.x, translatedCoord.y, 1))
		else:
			#arbitraraly massive wieght applied for walls
			self.add_point(currentPoint, Vector3(translatedCoord.x, translatedCoord.y, 99999999))
		mapCoordIdDict[nodes[i]] = currentPoint
		
		#Connect Nodes
		var nodeLeft = nodes[i] + Vector2(-1, 0)
		if mapCoordIdDict.has(nodeLeft):
			self.connect_points(mapCoordIdDict[nodeLeft], currentPoint)
		var nodeAbove = nodes[i] + Vector2(0, -1)
		if mapCoordIdDict.has(nodeAbove):
			self.connect_points(mapCoordIdDict[nodeAbove], currentPoint)
		currentPoint += 1

func get_path(currentVector, goalVector):
	#var obstacles = self.node.get_tree().get_nodes_in_group("obstruction")
	var rawVec = self.get_point_path(self.get_closest_point(Vector3(currentVector.x, currentVector.y, 1)), self.get_closest_point(Vector3(goalVector.x, goalVector.y, 1)))
	var points = []
	for i in range(rawVec.size()):
		#the 10 extra pixels on the x are to avoid getting snagged on corners
		if rawVec[i].x > rawVec[i-1].x:
			points.push_back(Vector2(rawVec[i].x - 10, rawVec[i].y))
		else:
			points.push_back(Vector2(rawVec[i].x + 10, rawVec[i].y))
	return Vector2Array(points)