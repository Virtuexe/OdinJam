package gameplay
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"
import "../data"

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

    main_game_state.player_info.velocity.x = clamp(main_game_state.player_info.velocity.x, -player_move_speed, player_move_speed)
    main_game_state.player_info.position.x += main_game_state.player_info.velocity.x * dt
    if main_game_state.player_info.velocity.x != 0 {
        player_animation_change(.Run)
        main_game_state.player_info.animation_progress += main_game_state.player_info.velocity.x
    }
    else {
        player_animation_change(.Idle)
        main_game_state.player_info.animation_progress += 1
    }
}
player_move :: proc(direction: data.Direction) {
    dt := rl.GetFrameTime()
    mult: f32 = 1
    main_game_state.player_info.direction = .Right
    if direction == .Left {
        mult = -1
        main_game_state.player_info.direction = .Left
    }
    main_game_state.player_info.velocity.x += player_move_acceleration * dt * mult
}
player_slide :: proc() {
    dt := rl.GetFrameTime()
    if main_game_state.player_info.velocity.x > 0 {
        main_game_state.player_info.velocity.x = max(0, main_game_state.player_info.velocity.x - player_friction * dt)
    } else if main_game_state.player_info.velocity.x < 0 {
        main_game_state.player_info.velocity.x = min(0, main_game_state.player_info.velocity.x + player_friction * dt)
    }
}
player_animation_change :: proc(player_animation: data.PlayerAnimation) {
    if main_game_state.player_info.animation != player_animation {
        main_game_state.player_info.animation_progress = 0
    }
    main_game_state.player_info.animation = player_animation
}