extends Control

# --

@export var tabs : Array[TabButton] = []

@export var entry_manager = Control

# --

var current_tab : TabButton

# --

func _ready() -> void:
	for tab in tabs:
		tab.new_tab_selected.connect(_change_tab_visibility)
	
	for tab in tabs:
		_change_tab_visibility(tab)
		tab.move_tab(true)
		break

func _change_tab_visibility(new_tab : TabButton) -> void:
	if not new_tab == current_tab:
		new_tab.entry_template.visible = true
		
		if not current_tab == null:
			current_tab.entry_template.visible = false
			current_tab.is_selected = false
			current_tab.move_tab(false)
		
		current_tab = new_tab
		entry_manager.change_tab(new_tab.category)
