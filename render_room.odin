package game
import rl "vendor:raylib"
import fmt "core:fmt"
import "core:math"

draw_room :: proc() {
    for tile, i in game_state.map_.tiles[game_state.room_index] {

        scaled_tile_width := f32(rl.GetScreenWidth()) / f32(len(game_state.map_.tiles[game_state.room_index]))
        scaled_tile_height := f32(ROOM_TEXTURE_SIZE.y) * (scaled_tile_width / f32(ROOM_TEXTURE_SIZE.x))
        x := f32(i) * scaled_tile_width
        y := f32(rl.GetScreenHeight()/2) - scaled_tile_height/2

        rl.DrawTexturePro(
            room_texture[tile.type],
            {0,0,f32(ROOM_TEXTURE_SIZE.x),f32(ROOM_TEXTURE_SIZE.y)},
            {x, y, scaled_tile_width, scaled_tile_width},
            {0,0},
            0,
            rl.WHITE
        )
    }
}