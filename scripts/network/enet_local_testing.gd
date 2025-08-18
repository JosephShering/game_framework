class_name LocalNetworkType
extends BaseNetworkType

const HOST = "localhost"
const PORT = 42069

func host_game(port: int) -> ENetMultiplayerPeer:
    var peer := ENetMultiplayerPeer.new()
    peer.create_server(port)
    
    return peer

func join_game(_id: int):
    var peer := ENetMultiplayerPeer.new()
    peer.create_client(HOST, PORT)
    
    return peer
    
