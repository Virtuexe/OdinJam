package game
import rl "vendor:raylib"

quit := false

main :: proc() {
    game_init()
    for !quit {
        game_iter()
    }
}