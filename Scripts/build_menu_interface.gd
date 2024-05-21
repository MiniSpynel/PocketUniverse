extends Control
signal structure_select(struct)
@export var starting_techs: Array[Tech] = []

var tabs: Dictionary = {}
var build_menu_tab = preload("res://Scenes/build_menu_tab.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Group techs by category
	for tech in starting_techs:
		if tech.category not in tabs:
			tabs[tech.category] = []
		tabs[tech.category].append(tech)

	# Create a tab for each category and populate it with techs
	for category in tabs.keys():
		var tab_instance = build_menu_tab.instantiate()
		add_child(tab_instance)
		tab_instance.structure_select.connect(structure_selected)
		tab_instance.name = Tech.Category.keys()[category]

		# Assuming build_menu_tab has an `add_tech` function to add Tech instances
		for tech in tabs[category]:
			tab_instance.add_tech(tech)

	print(tabs)

func structure_selected(struct):
	structure_select.emit(struct)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
