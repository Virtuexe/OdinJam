package game
import rl "vendor:raylib"
import fmt "core:fmt"
import "core:math"

ROOM_TEXTURE_SIZE :: [2]i32{16,32}
ROOM_SIZE :: [2]f32{16,32}
room_texture: [TileType]rl.Texture2D = {}

render_room_init :: proc() {
    room_texture[.Empty] = rl.LoadTexture("assets/Wall.png")
    room_texture[.Door] = rl.LoadTexture("assets/Door.png")
}
draw_room :: proc() {
    for tile, i in game_state.map_.tiles[game_state.room_index] {

        scaled_tile_width := render_get_scale_modifier() * f32(ROOM_SIZE.x)
        scaled_tile_height := render_get_scale_modifier() * f32(ROOM_SIZE.x)
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

render_get_scale_modifier :: proc() -> (modifier: f32) {
    scale_x := f32(rl.GetScreenWidth()) / (f32(ROOM_SIZE.x) * f32(len(game_state.map_.tiles[game_state.room_index])))
    scale_y := f32(rl.GetScreenHeight()) / f32(ROOM_SIZE.y)

    return min(scale_x, scale_y)
}