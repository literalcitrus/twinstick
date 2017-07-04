extends StaticBody2D

const arena_size = Vector2(1920, 1920)

func _ready():
	generate_walls()

func generate_walls():
	var segments = Vector2Array()
	
	segments.append(Vector2(-arena_size.x/2, -arena_size.y/2))
	segments.append(Vector2(arena_size.x/2, -arena_size.y/2))
	
	segments.append(Vector2(arena_size.x/2, -arena_size.y/2))
	segments.append(Vector2(arena_size.x/2, arena_size.y/2))
	
	segments.append(Vector2(arena_size.x/2, arena_size.y/2))
	segments.append(Vector2(-arena_size.x/2, arena_size.y/2))
	
	segments.append(Vector2(-arena_size.x/2, arena_size.y/2))
	segments.append(Vector2(-arena_size.x/2, -arena_size.y/2))
	
	get_shape(0).set_segments(segments)
	
	# move sprites
	get_node("TopWall").set_scale(Vector2(1, (arena_size.x+10)/128))
	get_node("TopWall").set_pos(Vector2(0, -arena_size.y/2))
	
	get_node("BottomWall").set_scale(Vector2(1, (arena_size.x+10)/128))
	get_node("BottomWall").set_pos(Vector2(0, arena_size.y/2))
	
	get_node("LeftWall").set_scale(Vector2(1, arena_size.y/128))
	get_node("LeftWall").set_pos(Vector2(-arena_size.x/2, 0))
	
	get_node("RightWall").set_scale(Vector2(1, arena_size.y/128))
	get_node("RightWall").set_pos(Vector2(arena_size.x/2, 0))
