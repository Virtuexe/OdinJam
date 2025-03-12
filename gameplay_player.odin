package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"

player_input :: proc() {

    if rl.IsKeyDown(.A) {
        player_move(.Left)
        if rl.IsKeyDown(.D) {
            player_move(.Right)
        }
    }
    else if rl.IsKeyDown(.D) {
        player_move(.Right)
    }
    else {
        player_slide()
    }

    dt := rl.GetFrameTime()

    game_state.player_info.velocity.x = clamp(game_state.player_info.velocity.x, -player_move_speed, player_move_speed)
    game_state.player_info.position.x += game_state.player_info.velocity.x * dt
    if game_state.player_info.velocity.x != 0 {
        player_animation_change(.Run)
        game_state.player_info.animation_progress += game_state.player_info.velocity.x
    }
    else {
        player_animation_change(.Idle)
        game_state.player_info.animation_progress += 1
    }
}
player_move :: proc(direction: Direction) {
    dt := rl.GetFrameTime()
    mult: f32 = 1
    game_state.player_info.direction = .Right
    if direction == .Left {
        mult = -1
        game_state.player_info.direction = .Left
    }
    game_state.player_info.velocity.x += player_move_acceleration * dt * mult
}
player_slide :: proc() {
    dt := rl.GetFrameTime()
    if game_state.player_info.velocity.x > 0 {
        game_state.player_info.velocity.x = max(0, game_state.player_info.velocity.x - player_friction * dt)
    } else if game_state.player_info.velocity.x < 0 {
        game_state.player_info.velocity.x = min(0, game_state.player_info.velocity.x + player_friction * dt)
    }
}
player_animation_change :: proc(player_animation: PlayerAnimation) {
    if game_state.player_info.animation != player_animation {
        game_state.player_info.animation_progress = 0
    }
    game_state.player_info.animation = player_animation
}