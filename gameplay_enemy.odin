package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"
import "core:math/rand"

gameplay_enemy_get_keys :: proc() -> (left: bool, right: bool, up: bool, use: bool) {
    if does_enemy_see_player() {
        left, right = enemy_move_towards_player()
        enemy.targeted_tile_door = nil
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
        door_tiles: [dynamic]int
        for tile,i in map_.tiles[enemy_info.room_index] {
            if tile.type == .Door {
                append(&door_tiles, i)
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