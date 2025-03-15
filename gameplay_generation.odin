package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"

MAP_EDITOR :: []string{"-D1-----D2-","-D1---D2-"}

DoorData :: struct {
    room_index: int,
    tile_index: int,
    is_open: bool,
    animation_in_progress: bool,
    animation_frame: f32,
}

read_map :: proc() {
    unhandled_doors: map[rune]DoorData
    for room, room_index in MAP_EDITOR {
        append(&game_state.map_.tiles, [dynamic]TileInfo{})
        expecting_identifier := false
        tile_index := 0
        for c in room {
            if expecting_identifier {
                if unhandled_door, ok := unhandled_doors[c]; ok {
                    unhandled_door_tile := &game_state.map_.tiles[unhandled_door.room_index][unhandled_door.tile_index]
                    current_door_tile := &game_state.map_.tiles[room_index][tile_index]

                    unhandled_door_tile.data_pointer = stack_push(&game_state.map_.stack, DoorData{room_index, tile_index, false, false, 0})
                    current_door_tile.data_pointer = stack_push(&game_state.map_.stack, DoorData{unhandled_door.room_index, unhandled_door.tile_index, false, false, 0})
                }
                unhandled_doors[c] = {room_index, tile_index, false, false, 0}
                expecting_identifier = false
                tile_index += 1
                continue
            }
            switch c {
                case tile_symbols[.Empty]:
                    append(last(game_state.map_.tiles[:]), TileInfo{.Empty, nil})
                    tile_index += 1
                case tile_symbols[.Door]:
                    append(last(game_state.map_.tiles[:]), TileInfo{.Door, nil})
                    expecting_identifier = true
                case:
                    assert(true, "Invalid symbol.")
            }
        }
    }
}

get_tile_position :: proc(room_index: int, tile_index: int) -> f32 {
    return (f32(tile_index) - f32(len(map_.tiles[room_index]))/2) * ROOM_SIZE.x + ROOM_SIZE.x/2
}