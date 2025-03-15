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
room_door_open_texture: rl.Texture2D = {}
room_door_open_sound: rl.Sound = {}
room_tiles_slide := [TileType]i32 {
    .Empty = 4,
    .Door = -1,
}
room_door_texture_slide_count: i32 = 4
room_door_texture_next_slide_on_progress: f32 = 0.3

render_room_init :: proc() {
    // Load room textures from memory
    room_tiles_image := rl.LoadImageFromMemory(".png", raw_data(room_tiles_data), i32(len(room_tiles_data)))
    room_door_image := rl.LoadImageFromMemory(".png", raw_data(room_door_open_data), i32(len(room_door_open_data)))
    
    room_tiles_texture = rl.LoadTextureFromImage(room_tiles_image)
    room_door_open_texture = rl.LoadTextureFromImage(room_door_image)
    
    rl.UnloadImage(room_tiles_image)
    rl.UnloadImage(room_door_image)
    
    // Load door sound from memory
    door_wave := rl.LoadWaveFromMemory(".mp3", raw_data(room_door_sound_data), i32(len(room_door_sound_data)))
    room_door_open_sound = rl.LoadSoundFromWave(door_wave)
    rl.UnloadWave(door_wave)
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

        texture: rl.Texture2D
        rectangle: rl.Rectangle
        if tile.type == .Door {
            door_data := stack_peek_at(&map_.stack, tile.data_pointer.(int), DoorData)
            if door_data.is_open {
                if door_data.animation_in_progress {
                    texture = room_door_open_texture 
                    rectangle = {f32(i32(door_data.animation_frame / room_door_texture_next_slide_on_progress) % room_door_texture_slide_count) * f32(ROOM_TEXTURE_SIZE.x), 0, f32(ROOM_TEXTURE_SIZE.x),f32(ROOM_TEXTURE_SIZE.y)}
                } else {
                    texture = room_tiles_texture
                    rectangle = {f32(ROOM_TEXTURE_SIZE.x * 3),0,f32(ROOM_TEXTURE_SIZE.x),f32(ROOM_TEXTURE_SIZE.y)}
                }
            }
            else {
                if door_data.animation_in_progress {
                    texture = room_door_open_texture 
                    rectangle = {f32(room_door_texture_slide_count) * f32(ROOM_TEXTURE_SIZE.x) - f32(i32(door_data.animation_frame / room_door_texture_next_slide_on_progress) % room_door_texture_slide_count) * f32(ROOM_TEXTURE_SIZE.x), 0, f32(ROOM_TEXTURE_SIZE.x),f32(ROOM_TEXTURE_SIZE.y)}
                } else {
                    texture = room_tiles_texture
                    rectangle = {f32(ROOM_TEXTURE_SIZE.x * 7),0,f32(ROOM_TEXTURE_SIZE.x),f32(ROOM_TEXTURE_SIZE.y)}
                }
            }
        }
        else {
            texture = room_tiles_texture
            rectangle = {f32(ROOM_TEXTURE_SIZE.x * room_tiles_slide[tile.type]),0,f32(ROOM_TEXTURE_SIZE.x),f32(ROOM_TEXTURE_SIZE.y)}
        }

        color := rl.WHITE
        if game_state.game_over {
            color = rl.RED
        }

        rl.DrawTexturePro(
            texture,
            rectangle,
            {x, y, scaled_tile_width, scaled_tile_height},
            {0, 0},
            0,
            color
        )
    }
}

render_get_scale_modifier :: proc() -> (modifier: f32) {
    scale_x := f32(rl.GetScreenWidth()) / (ROOM_SIZE.x * f32(len(game_state.map_.tiles[game_state.room_index])))
    scale_y := f32(rl.GetScreenHeight()) / ROOM_SIZE.y

    return min(scale_x, scale_y)
}