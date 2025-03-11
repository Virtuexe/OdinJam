package game
import rl "vendor:raylib"
import "data"
import "gameplay"
import "render"


default_window_size :: [2]i32{512,512}

game_state := data.GameState{}

game_init :: proc() {
    rl.SetConfigFlags(rl.ConfigFlags{rl.ConfigFlag.WINDOW_RESIZABLE});
    rl.InitWindow(default_window_size.x,default_window_size.y,"Game");
    rl.SetTargetFPS(60)
    gameplay.init(&game_state)
    render.init(&game_state)
}
game_iter :: proc() {
    if rl.WindowShouldClose() {
        quit = true
        return
    }
    gameplay.iter()
    render.iter()
}