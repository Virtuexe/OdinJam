package game
import rl "vendor:raylib"
import fmt "core:fmt"
import "core:math"

TileType :: enum {
    Empty,
    Door,
}
tile_symbols := [TileType]rune {
    .Empty = '-',
    .Door = 'D'
}

ROOM_TEXTURE_SIZE :: [2]i32{16,48}
ROOM_SIZE :: [2]f32{16,48}
room_tiles_texture: rl.Texture2D = {}
room_tiles_slide := [TileType]i32 {
    .Empty = 4,
    .Door = 6,
}

render_room_init :: proc() {
    room_tiles_texture = rl.LoadTexture("assets/Room/tiles.png")
}
draw_room :: proc() {
    tiles := game_state.map_.tiles[game_state.room_index]
    total_width := f32(len(tiles)) * render_get_scale_modifier() * f32(ROOM_SIZE.x)
    start_x := f32(rl.GetScreenWidth())/2 - total_width/2

    for tile, i in game_state.map_.tiles[game_state.room_index] {

        scaled_tile_width := render_get_scale_modifier() * f32(ROOM_SIZE.x)
        scaled_tile_height := render_get_scale_modifier() * f32(ROOM_SIZE.y)
        x := start_x + f32(i) * scaled_tile_width
        y := f32(rl.GetScreenHeight()/2) - scaled_tile_height/2

        rl.DrawTexturePro(
            room_tiles_texture,
            {f32(ROOM_TEXTURE_SIZE.x * room_tiles_slide[tile.type]),0,f32(ROOM_TEXTURE_SIZE.x),f32(ROOM_TEXTURE_SIZE.y)},
            {x, y, scaled_tile_width, scaled_tile_height},
            {0, 0},
            0,
            rl.WHITE
        )
    }
}

render_get_scale_modifier :: proc() -> (modifier: f32) {
    scale_x := f32(rl.GetScreenWidth()) / (ROOM_SIZE.x * f32(len(game_state.map_.tiles[game_state.room_index])))
    scale_y := f32(rl.GetScreenHeight()) / ROOM_SIZE.y

    return min(scale_x, scale_y)
}