package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"

gameplay_init :: proc() {
    player_info.position = {0, ROOM_SIZE.y/7}
    enemy_info.position = {0, ROOM_SIZE.y/7}
    read_map()
    enemy_info.room_index = len(map_.tiles) - 1
}
gameplay_iter :: proc() {
    if game_state.game_over {
        return
    }
    #reverse for room_tile_index, i in map_.doors_need_handle {
        door_data := stack_peek_at(&map_.stack, map_.tiles[room_tile_index[0]][room_tile_index[1]].data_pointer.(int), DoorData)
        door_data.animation_frame += rl.GetFrameTime()
        if door_data.animation_frame >= room_door_texture_next_slide_on_progress * f32(room_door_texture_slide_count) {
            door_data.animation_frame = 0
            door_data.animation_in_progress = false
            ordered_remove(&map_.doors_need_handle, i)
        }
    }

    player_input(rl.IsKeyDown(.A), rl.IsKeyDown(.D), rl.IsKeyPressed(.W), rl.IsKeyPressed(.SPACE), player_info, true)
    player_input(gameplay_enemy_get_keys(), enemy_info, false)
}