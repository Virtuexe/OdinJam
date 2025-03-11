package render
import rl "vendor:raylib"
import fmt "core:fmt"
import "core:math"
import "../data"

PLAYER_SIZE :: rl.Vector2{128,128}

main_game_state: ^data.GameState

player_texture: [data.PlayerAnimation]rl.Texture2D = {}
player_texture_slide_count: [data.PlayerAnimation]int = {
    .Idle = 6,
    .Run = 9,
}
player_texture_next_slide_on_progress: [data.PlayerAnimation]f32 = {
    .Idle = 20,
    .Run = 300,
}
player_texture_size : rl.Vector2 = {64,64}

init :: proc(game_state: ^data.GameState) {
    main_game_state = game_state

    player_texture[.Idle] = rl.LoadTexture("assets/Idle/Thin.png")
    player_texture[.Run] = rl.LoadTexture("assets/Run/Run.png")
}
iter :: proc() {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.GRAY)
    draw_room()
    draw_player()
}
draw_room :: proc() {
    for tile in main_game_state.map_.tiles[main_game_state.room_index] {
        
    }
}
draw_player :: proc() {
    texture_size := player_texture_size
    texture_flip_mult:f32 = 1
    if main_game_state.player_info.direction == .Left {
        texture_flip_mult = -1
    }

    ani := main_game_state.player_info.animation
    ani_progress := main_game_state.player_info.animation_progress
    ani_next_slide_on_progress := player_texture_next_slide_on_progress[ani]
    ani_slide_count := player_texture_slide_count[ani]
    slide := int(ani_progress / ani_next_slide_on_progress) % ani_slide_count

    texture_rectangle := rl.Rectangle{texture_size.x * f32(slide), 0, texture_flip_mult * texture_size.x, texture_size.y}

    dest_rectangle := rl.Rectangle{
        f32(rl.GetScreenWidth()) / 2 + main_game_state.player_info.position.x,
        f32(rl.GetScreenHeight()) / 2 + main_game_state.player_info.position.y,
        PLAYER_SIZE.x,
        PLAYER_SIZE.y
    }

    origin := PLAYER_SIZE/2

    rl.DrawTexturePro(player_texture[main_game_state.player_info.animation], texture_rectangle, dest_rectangle, origin, 0, rl.WHITE)

    rl.DrawRectangle(rl.GetScreenWidth() / 2 - 5, rl.GetScreenHeight() / 2 - 5, 10, 10, rl.BLUE)
}