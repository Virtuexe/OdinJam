package game
import rl "vendor:raylib"
import fmt "core:fmt"
import "core:math"

render_init :: proc() {
    render_player_init()
    render_room_init()
}
render_iter :: proc() {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.GRAY)
    draw_room()
    draw_player()
}