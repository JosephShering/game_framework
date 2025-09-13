class_name SuperSimpleInventory
extends Resource

var items : Dictionary[Variant, int] = {}

func add(item, amount = 1) -> void:
    if items.has(item):
        items[item] += amount
    else:
        items[item] = amount

func has_item(item, amount = 1) -> bool:
    return items.has(item) and items[item] >= amount

func remove(item, amount = 1) -> int:
    var removed_count := 0
    
    if items.has(item):
        removed_count = min(items[item], amount)
        items[item] -= removed_count
    
    return removed_count
