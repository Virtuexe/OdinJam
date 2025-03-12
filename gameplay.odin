package game
import rl "vendor:raylib"
import st "core:strings"
import fmt "core:fmt"

player_move_speed: f32 = 100
player_move_acceleration: f32 = 600
player_friction: f32 = 800

gameplay_init :: proc() {
    read_map()
}
gameplay_iter :: proc() {
    player_input()
}