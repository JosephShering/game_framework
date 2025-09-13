class_name LootTable
extends Resource

@export var items : Array[LootTableItem]

func drop() -> Array[LootTableItem]:
    var total := 0
    var dropped_items : Array[LootTableItem] = []
    
    total = items.reduce(_sum_chance, total)

    var rand := randi_range(0, total)
    for item in items:
        if item.chance == 0: # chance of 0 means it is guarenteed to drop
            dropped_items.append(item)
            continue
        
        rand -= item.amount
        
        if rand <= 0 and item != null:
            dropped_items.append(item)
            break
    
    return dropped_items

func _get_item(lti: LootTableItem) -> Object:
    return lti.item

func _sum_chance(acc: int, lti: LootTableItem) -> int:
    return acc + lti.chance
