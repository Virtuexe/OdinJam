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
                if _, ok := unhandled_doors[c]; ok {
                    game_state.map_.tiles[unhandled_doors[c].room_index][unhandled_doors[c].tile_index].data_pointer = len(game_state.map_.tiles)
                    append_array(&game_state.map_.data, transmute([size_of(DoorData)]byte)DoorData{room_index, tile_index})
                    game_state.map_.tiles[room_index][tile_index].data_pointer = len(game_state.map_.data)
                    append_array(&game_state.map_.data, transmute([size_of(DoorData)]byte)DoorData{unhandled_doors[c].room_index, unhandled_doors[c].tile_index})
                }
                expecting_identifier = false
                continue
            }
            tile_index += 1
            switch c {
                case tile_symbols[.Empty]:
                    append(last(game_state.map_.tiles[:]), TileInfo{.Empty, nil})
                case tile_symbols[.Door]:
                    append(last(game_state.map_.tiles[:]), TileInfo{.Door, nil})
                    expecting_identifier = true
                case:
                    assert(true, "Invalid symbol.")
            }
        }
    }

    for room in game_state.map_.tiles {
        fmt.print("room:")
        for tile in room {
            fmt.print(tile_symbols[tile.type])
            if (tile.type == .Door) {
                //fmt.print((cast(^DoorData)&game_state.map_.data[tile.data_pointer.(int)])^)
            }
        }
        fmt.print('\n')
    }
}