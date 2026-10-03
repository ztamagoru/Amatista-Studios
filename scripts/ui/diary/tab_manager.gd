extends Control

# --

@export var tabs : Array[TabButton] = []

# --

var current_tab : TabButton

# --

func _ready() -> void:
	for tab in tabs:
		tab.new_tab_selected.connect(_change_tab_visibility)
	
	current_tab = get_child(0)
	current_tab.is_selected = true
	current_tab.move_tab(true)
	
	_change_tab_visibility(get_child(0))

func _change_tab_visibility(new_tab : TabButton) -> void:
	if not new_tab == current_tab:
		current_tab.entry_template.visible = false
		new_tab.entry_template.visible = true
		
		current_tab.is_selected = false
		current_tab.move_tab(false)
		
		current_tab = new_tab
