package game
import rl "vendor:raylib"
import "core:math/rand"


default_window_size :: [2]i32{512,512}

game_state := GameState{}
map_ := &game_state.map_
player_info := &game_state.player_info
enemy_info := &game_state.enemy_info

game_init :: proc() {
    rl.SetConfigFlags(rl.ConfigFlags{rl.ConfigFlag.WINDOW_RESIZABLE});
    rl.SetTraceLogLevel(.NONE)
    rl.InitWindow(default_window_size.x,default_window_size.y,"Game");
    rl.SetTargetFPS(60)
    rl.InitAudioDevice()

    gameplay_init()
    render_init()
}
game_iter :: proc() {
    if rl.WindowShouldClose() {
        quit = true
        return
    }
    gameplay_iter()
    render_iter()
    player_info.last_animation_progress = player_info.animation_progress
}