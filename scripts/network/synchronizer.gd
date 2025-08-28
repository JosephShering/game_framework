class_name PlayerSynchronizer
extends MultiplayerSynchronizer

#func _ready() -> void:
    #if is_multiplayer_authority():
        #local_player_ready.rpc()
        #
#@rpc("any_peer", "call_local", "reliable")
#func local_player_ready() -> void:
    #var remote_id := multiplayer.get_remote_sender_id()
    #set_visibility_for(remote_id, true)
    #
#@rpc("any_peer", "reliable")
#func respond() -> void:
    #var remote_id := multiplayer.get_remote_sender_id()
    #set_visibility_for(remote_id, true)
