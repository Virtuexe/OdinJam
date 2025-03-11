package gameplay
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"
import "../data"
import "../libraries/general"

main_game_state: ^data.GameState

player_move_speed: f32 = 100
player_move_acceleration: f32 = 600
player_friction: f32 = 800

MAP_EDITOR :: []string{"--D1","-D1"}

init :: proc(game_state: ^data.GameState) {
    main_game_state = game_state

    unhandled_doors: map[rune]data.DoorData
    for room, room_index in MAP_EDITOR {
        append(&main_game_state.map_.tiles, [dynamic]data.TileInfo{})
        expecting_identifier := false
        tile_index := 0
        for c in room {
            if expecting_identifier {
                if _, ok := unhandled_doors[c]; ok {
                    main_game_state.map_.tiles[unhandled_doors[c].room_index][unhandled_doors[c].tile_index].data_pointer = len(main_game_state.map_.tiles)
                    general.append_array(&main_game_state.map_.data, transmute([size_of(data.DoorData)]byte)data.DoorData{room_index, tile_index})
                    main_game_state.map_.tiles[room_index][tile_index].data_pointer = len(main_game_state.map_.data)
                    general.append_array(&main_game_state.map_.data, transmute([size_of(data.DoorData)]byte)data.DoorData{unhandled_doors[c].room_index, unhandled_doors[c].tile_index})
                }
                expecting_identifier = false
                continue
            }
            tile_index += 1
            switch c {
                case data.TILE_SYMBOL[.Empty]:
                    append(general.last(main_game_state.map_.tiles[:]), data.TileInfo{.Empty, nil})
                case data.TILE_SYMBOL[.Door]:
                    append(general.last(main_game_state.map_.tiles[:]), data.TileInfo{.Door, nil})
                    expecting_identifier = true
                case:
                    assert(true, "Invalid symbol.")
            }
        }
    }
}
iter :: proc() {
    player_input()
}