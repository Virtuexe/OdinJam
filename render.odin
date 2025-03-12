package game
import rl "vendor:raylib"
import fmt "core:fmt"
import "core:math"

PLAYER_SIZE :: rl.Vector2{128,128}

player_texture: [PlayerAnimation]rl.Texture2D = {}
player_texture_slide_count: [PlayerAnimation]int = {
    .Idle = 6,
    .Run = 9,
}
player_texture_next_slide_on_progress: [PlayerAnimation]f32 = {
    .Idle = 20,
    .Run = 300,
}
player_texture_size : rl.Vector2 = {64,64}

render_init :: proc() {
    player_texture[.Idle] = rl.LoadTexture("assets/Idle/Thin.png")
    player_texture[.Run] = rl.LoadTexture("assets/Run/Run.png")
}
render_iter :: proc() {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.GRAY)
    draw_room()
    draw_player()
}
draw_room :: proc() {
    for tile in game_state.map_.tiles[game_state.room_index] {
        
    }
}
draw_player :: proc() {
    texture_size := player_texture_size
    texture_flip_mult:f32 = 1
    if game_state.player_info.direction == .Left {
        texture_flip_mult = -1
    }

    ani := game_state.player_info.animation
    ani_progress := game_state.player_info.animation_progress
    ani_next_slide_on_progress := player_texture_next_slide_on_progress[ani]
    ani_slide_count := player_texture_slide_count[ani]
    slide := int(ani_progress / ani_next_slide_on_progress) % ani_slide_count

    texture_rectangle := rl.Rectangle{texture_size.x * f32(slide), 0, texture_flip_mult * texture_size.x, texture_size.y}

    dest_rectangle := rl.Rectangle{
        f32(rl.GetScreenWidth()) / 2 + game_state.player_info.position.x,
        f32(rl.GetScreenHeight()) / 2 + game_state.player_info.position.y,
        PLAYER_SIZE.x,
        PLAYER_SIZE.y
    }

    origin := PLAYER_SIZE/2

    rl.DrawTexturePro(player_texture[game_state.player_info.animation], texture_rectangle, dest_rectangle, origin, 0, rl.WHITE)

    rl.DrawRectangle(rl.GetScreenWidth() / 2 - 5, rl.GetScreenHeight() / 2 - 5, 10, 10, rl.BLUE)
}