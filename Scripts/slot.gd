extends PanelContainer

signal slot_clicked(index: int, button: int)

@onready var quantity = $MarginContainer/Quantity
@onready var texture_rect = $MarginContainer/TextureRect


func set_slot_data(slot_data: SlotData):
	var item_data = slot_data.item_data
	
	texture_rect.texture = item_data.texture
	
	if slot_data.quantity > 1:
		quantity.text = "%s" % slot_data.quantity
		quantity.show()


func _on_gui_input(event):
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT \
			or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)
