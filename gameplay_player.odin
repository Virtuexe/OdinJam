package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"

player_move_speed: f32 = 25
player_move_acceleration: f32 = 150
player_friction: f32 = 200

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

        
        last_anim_progress := game_state.player_info.animation_progress
        progress := player_texture_next_slide_on_progress[.Run]

        game_state.player_info.animation_progress += abs(game_state.player_info.velocity.x) * dt
        if player_animation_passed_slide(.Run, {1}) {
            rl.PlaySound(player_sound_step[0])
        }
        else if player_animation_passed_slide(.Run, {3}) {
            rl.PlaySound(player_sound_step[1])
        }
    }
    else {
        player_animation_change(.Idle)
        game_state.player_info.animation_progress += dt
    }
    
    room_width: f32 = ROOM_SIZE.x * f32(len(map_.tiles[game_state.room_index]))
    min_x := -room_width / 2 + PLAYER_SIZE.x / 4
    max_x := room_width / 2 - PLAYER_SIZE.x / 4

    if player_info.position.x < min_x {
        player_info.velocity.x = 0
        player_info.position.x = min_x
    } else if player_info.position.x > max_x {
        player_info.velocity.x = 0
        player_info.position.x = max_x
    }

    player_room_interact()
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

player_room_interact :: proc() {
    room := &map_.tiles[game_state.room_index]

    center_tile := (len(room) + 1) / 2
    tile_offset_modifier: f32 
    if len(room) % 2 != 0 {
        tile_offset_modifier = 1
    }
    else {
        tile_offset_modifier = 0
    }

    tile_index := int(f32(center_tile) + (player_info.position.x - ROOM_SIZE.x/2*tile_offset_modifier)  / ROOM_SIZE.x)
    tile_index = min(max(0, tile_index), len(room) - 1)
    tile := &room[tile_index]

    if (rl.IsKeyPressed(.SPACE)) {
        #partial switch room[tile_index].type {
            case .Door:
                game_state.room_index = stack_peek_at(&map_.stack, tile.data_pointer.(int), DoorData).room_index
        }
    }
}