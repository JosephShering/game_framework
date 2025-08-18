class_name ResolutionsMenuButton
extends MenuButton

func _ready() -> void:
    var menu := get_popup()
    
    for resol in Settings.resolutions.keys():
        menu.add_item(resol)
        
    menu.index_pressed.connect(func(index: int) -> void:
        var key := menu.get_item_text(index)
        var resolution := Settings.resolutions[key]
        
        get_window().size = resolution
    )
