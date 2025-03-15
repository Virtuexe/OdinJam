package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"
import "core:math/rand"

gameplay_enemy_get_keys :: proc() -> (left: bool, right: bool, up: bool, use: bool) {
    if abs(game_state.player_info.position.x - enemy_info.position.x) < ENEMY_SIZE.x/3 && enemy_info.room_index == game_state.player_info.room_index {
        game_state.game_over = true
    }

    if does_enemy_see_player() {
        // left, right = enemy_move_towards_player()
        // enemy.targeted_tile_door = nil
        left, right, up, use = enemy_move_towards_door()
    }
    else {
        left, right, up, use = enemy_move_towards_door()
    }
    return
}
enemy_move_towards_player :: proc() -> (left: bool, right: bool) {
    return enemy_move_towards(player_info.position.x)
}
enemy_move_towards_door :: proc() -> (left: bool, right: bool, up: bool, use: bool) {
    if enemy.targeted_tile_door == nil {
        lowest_chance := max(int)
        door_tiles: [dynamic]int
        for door,i in enemy.explore_door_chance[enemy_info.room_index] {
            if door.chance < lowest_chance {
                clear(&door_tiles)
                append(&door_tiles, door.tile_index)
                lowest_chance = door.chance
            }
            else if door.chance == lowest_chance {
                append(&door_tiles, door.tile_index)
            }
        }
        if len(door_tiles) == 0 {
            return
        } 
        enemy.targeted_tile_door = rand.choice(door_tiles[:])
    }
    left, right = enemy_move_towards(get_tile_position(enemy_info.room_index, enemy.targeted_tile_door.(int)))
    room_index, tile_index := player_get_tile_index(enemy_info, true)
    if tile_index == enemy.targeted_tile_door {
        door_data := stack_peek_at(&map_.stack, map_.tiles[room_index][tile_index].data_pointer.(int), DoorData)
        if !door_data.is_open && !door_data.animation_in_progress {
            use = true
        }
        else if door_data.is_open && !door_data.animation_in_progress {
            up = true
            enemy.explore_door_chance[room_index][get_door_index(room_index,tile_index)].chance += 1
            enemy.targeted_tile_door = nil
        }
    }
    return
}
does_enemy_see_player :: proc() -> bool {
    player := player_info
    enemy := enemy_info

    return player.room_index == enemy.room_index
}
enemy_move_towards :: proc(dest: f32) -> (left: bool, right: bool) {
    if enemy_info.position.x < dest {
        right = true
    }
    else if enemy_info.position.x > dest {
        left = true
    }
    return
}
get_door_index :: proc(room_index: int, tile_index: int) -> (door_index: int) {
    for current_tile_index in 0..<len(map_.tiles[room_index]) {
        if current_tile_index == tile_index {
            return
        }
        if map_.tiles[room_index][current_tile_index].type == .Door {
            door_index += 1
        }
    }
    fmt.panicf("error")
}