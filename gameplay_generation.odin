package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"

MAP_EDITOR :: []string{"--D1","-D1"}

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

                    unhandled_door_tile.data_pointer = stack_push(&game_state.map_.stack, DoorData{room_index, tile_index})
                    current_door_tile.data_pointer = stack_push(&game_state.map_.stack, DoorData{unhandled_door.room_index, unhandled_door.tile_index})
                }
                unhandled_doors[c] = {room_index, tile_index}
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
    // for room in game_state.map_.tiles {
    //     fmt.print("room:")
    //     for tile in room {
    //         fmt.print(tile_symbols[tile.type])
    //         if (tile.type == .Door) {
    //             if (tile.data_pointer != nil) {
    //                 fmt.print((stack_peek_at(&game_state.map_.stack, tile.data_pointer.(int), DoorData))^)
    //             }
    //             else {
    //                 fmt.print('X')
    //             }
    //         }
    //     }
    //     fmt.print('\n')
    // }
}