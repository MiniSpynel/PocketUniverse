extends Resource
class_name InventoryData

signal inventory_interact(inventory_data: InventoryData, index: int, button: int)

@export var slot_data: Array[SlotData]

func grab_slot_data(index: int):
	var data = slot_data[index]
	
	if data:
		return data
	else:
		return null

func on_slot_clicked(index: int, button: int):
	inventory_interact.emit(self, index, button)

