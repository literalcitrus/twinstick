# gear_data_loader.gd

# loads an item database from a specified file and creates a gear list

const Gear = preload("res://entities/items/gear.gd")

func load_gear_data(path):
	var gear_dict = {}
	var data_dict = get_gear_dict(path)
	# for each item, create a gear object and save into dict
	for item in data_dict["gear"]:
		var new_gear = Gear.new()
		new_gear.item_name = item["name"]
		new_gear.item_id = item["id"]
		gear_dict[str(item["id"])] = new_gear
	
	return gear_dict

func get_gear_dict(path):
	# load file and parse JSON
	var file = File.new()
	if (file.file_exists(path)):
		file.open(path, File.READ)
		var content = file.get_as_text()
		var data_dict = {}
		data_dict.parse_json(content)
		return data_dict
	else:
		print("ERROR: Cannot find gear file: " + str(path))
		return null