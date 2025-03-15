package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"

player_move_speed: f32 = 25
player_move_acceleration: f32 = 150
player_friction: f32 = 200

player_input :: proc(left:bool, right:bool, up:bool, use:bool, player_info: ^PlayerInfo, is_player: bool) {

    if left {
        player_move(.Left, player_info)
        if right {
            player_move(.Right, player_info)
        }
    }
    else if right {
        player_move(.Right, player_info)
    }
    else {
        player_slide(player_info)
    }

    dt := rl.GetFrameTime()
    player_info.velocity.x = clamp(player_info.velocity.x, -player_move_speed, player_move_speed)
    player_info.position.x += player_info.velocity.x * dt
    if player_info.velocity.x != 0 {
        player_animation_change(.Run, player_info)

        
        last_anim_progress := player_info.animation_progress
        progress := player_texture_next_slide_on_progress[.Run]

        player_info.animation_progress += abs(player_info.velocity.x) * dt
        if player_info.room_index == game_state.room_index {
            if player_animation_passed_slide(.Run, {1}) {
                rl.PlaySound(player_sound_step[0])
            }
            else if player_animation_passed_slide(.Run, {3}) {
                rl.PlaySound(player_sound_step[1])
            }
        }
    }
    else {
        player_animation_change(.Idle, player_info)
        player_info.animation_progress += dt
    }
    
    room_width: f32 = ROOM_SIZE.x * f32(len(map_.tiles[player_info.room_index]))
    min_x := -room_width / 2 + PLAYER_SIZE.x / 4
    max_x := room_width / 2 - PLAYER_SIZE.x / 4

    if player_info.position.x < min_x {
        player_info.velocity.x = 0
        player_info.position.x = min_x
    } else if player_info.position.x > max_x {
        player_info.velocity.x = 0
        player_info.position.x = max_x
    }

    player_room_interact(player_info, is_player, up, use)
}
player_move :: proc(direction: Direction, player_info: ^PlayerInfo) {
    dt := rl.GetFrameTime()
    mult: f32 = 1
    player_info.direction = .Right
    if direction == .Left {
        mult = -1
        player_info.direction = .Left
    }
    player_info.velocity.x += player_move_acceleration * dt * mult
}
player_slide :: proc(player_info: ^PlayerInfo) {
    dt := rl.GetFrameTime()
    if player_info.velocity.x > 0 {
        player_info.velocity.x = max(0, player_info.velocity.x - player_friction * dt)
    } else if player_info.velocity.x < 0 {
        player_info.velocity.x = min(0, player_info.velocity.x + player_friction * dt)
    }
}
player_animation_change :: proc(player_animation: PlayerAnimation, player_info: ^PlayerInfo) {
    if player_info.animation != player_animation {
        player_info.animation_progress = 0
    }
    player_info.animation = player_animation
}

player_room_interact :: proc(player_info: ^PlayerInfo, is_player: bool, up: bool, use: bool) {
    room_index, tile_index := player_get_tile_index(player_info,true)
    tile := &map_.tiles[room_index][tile_index]

    if use {
        #partial switch tile.type {
            case .Door:
                player_door_open(player_info, room_index, tile_index)
        }
    }

    if up {
        player_door_enter(player_info, is_player, tile)
    }
}
player_door_open :: proc(player_info: ^PlayerInfo, room_index, tile_index: int) {
    tile := &map_.tiles[room_index][tile_index]
    door_data := stack_peek_at(&map_.stack, tile.data_pointer.(int), DoorData)
    door_data2 := stack_peek_at(&map_.stack, map_.tiles[door_data.room_index][door_data.tile_index].data_pointer.(int), DoorData)

    if door_data.animation_in_progress {
        return
    }

    rl.PlaySound(room_door_open_sound)

    door_data.animation_in_progress = true
    door_data2.animation_in_progress = true
    door_data.is_open = !door_data.is_open
    door_data2.is_open = !door_data2.is_open
    append(&map_.doors_need_handle, [2]int{room_index,tile_index})
    append(&map_.doors_need_handle, [2]int{door_data.room_index,door_data.tile_index})
}
player_door_enter :: proc(player_info: ^PlayerInfo, is_player: bool, tile: ^TileInfo) {
    if tile.type != .Door {
        return
    }
    door_data := stack_peek_at(&map_.stack, tile.data_pointer.(int), DoorData)

    if !door_data.is_open || door_data.animation_in_progress {
        return
    }

    if is_player {
        game_state.room_index = door_data.room_index
    }
    player_info.room_index = door_data.room_index

    room := &map_.tiles[door_data.room_index]
    tile := &room[door_data.tile_index]
    player_info.position.x = (f32(door_data.tile_index) - f32(len(room))/2) * ROOM_SIZE.x + ROOM_SIZE.x/2
}
player_get_tile :: proc(player_info: ^PlayerInfo, center: bool) -> (room: ^[dynamic]TileInfo, tile: ^TileInfo) {
    room_index, tile_index := player_get_tile_index(player_info, center)
    return &map_.tiles[room_index], &map_.tiles[room_index][tile_index]
}
player_get_tile_index :: proc(player_info: ^PlayerInfo, center: bool) -> (room_index: int, tile_index: int) {
    room_index = player_info.room_index
    room := &map_.tiles[player_info.room_index]
    center_tile := (len(room) + 1) / 2
    tile_offset := ROOM_SIZE.x/2

    tile_offset_modifier: f32 
    if center {
        if len(room) % 2 != 0 {
            tile_offset_modifier = 1
        }
        else {
            tile_offset_modifier = 0
        }
    }
    tile_offset *=  tile_offset_modifier
    tile_index = int(f32(center_tile) + (player_info.position.x - tile_offset) / ROOM_SIZE.x)
    tile_index = min(max(0, tile_index), len(room) - 1)
    return
}

