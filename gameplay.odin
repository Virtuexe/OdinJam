package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"

gameplay_init :: proc() {
    player_info.position = {0, ROOM_SIZE.y/7}
    read_map()
}
gameplay_iter :: proc() {
    player_input()
}