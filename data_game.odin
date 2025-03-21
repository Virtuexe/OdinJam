package game
import rl "vendor:raylib"

GameState :: struct {
    player_info: PlayerInfo,
    enemy: Enemy,
    room_index: int,
    map_: Map,
    game_over: bool,
    score: f32,
}
Map :: struct {
    tiles: [dynamic][dynamic]TileInfo,
    stack: Stack,
    doors_need_handle: [dynamic][2]int,
}
TileInfo :: struct {
    type: TileType,
    data_pointer: Maybe(int),
}