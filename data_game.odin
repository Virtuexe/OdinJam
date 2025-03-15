package game
import rl "vendor:raylib"

GameState :: struct {
    player_info: PlayerInfo,
    room_index: int,
    map_: Map,
}
Map :: struct {
    tiles: [dynamic][dynamic]TileInfo,
    stack: Stack,
}
TileInfo :: struct {
    type: TileType,
    data_pointer: Maybe(int),
}
DoorData :: struct {
    room_index: int,
    tile_index: int,
}