extends Resource
class_name Tech

enum Category {BASE, FURNITURE, NATURE, OTHERS}

@export var name: String = "null"
@export var texture: Texture2D = null
@export var category: Category = 0
@export var object: PackedScene = null
