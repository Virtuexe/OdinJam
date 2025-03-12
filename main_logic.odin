package game
import rl "vendor:raylib"


default_window_size :: [2]i32{512,512}

game_state := GameState{}

game_init :: proc() {
    rl.SetConfigFlags(rl.ConfigFlags{rl.ConfigFlag.WINDOW_RESIZABLE});
    rl.InitWindow(default_window_size.x,default_window_size.y,"Game");
    rl.SetTargetFPS(60)
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
}