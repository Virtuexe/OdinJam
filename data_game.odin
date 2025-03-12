package game
import rl "vendor:raylib"

GameState :: struct {
    player_info: PlayerInfo,
    room_index: int,
    map_: Map,
}
Map :: struct {
    tiles: [dynamic][dynamic]TileInfo,
    data: [dynamic]byte,
}
TileInfo :: struct {
    type: TileType,
    data_pointer: Maybe(int),
}
TileType :: enum {
    Empty,
    Door,
}
tile_symbols := [TileType]rune {
    .Empty = '-',
    .Door = 'D'
}
DoorData :: struct {
    room_index: int,
    tile_index: int,
}