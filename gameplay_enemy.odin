package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"

gameplay_enemy_get_keys :: proc() -> (left: bool, right: bool, up: bool, use: bool) {
    player := player_info
    enemy := enemy_info

    if does_enemy_see_player() {
        left, right = enemy_move_towards_player()
        use = true
    }
    else {
        tile: ^TileInfo
        _, tile = player_get_tile(enemy, true)
        if tile.type == .Door {
            
        }
    }
    return
}
enemy_move_towards_player :: proc() -> (left: bool, right: bool) {
    player := player_info
    enemy := enemy_info

    if enemy.position.x < player.position.x {
        right = true
    }
    else if enemy.position.x > player.position.x {
        left = true
    }
    return
}
does_enemy_see_player :: proc() -> bool {
    player := player_info
    enemy := enemy_info

    return player.room_index == enemy.room_index
}