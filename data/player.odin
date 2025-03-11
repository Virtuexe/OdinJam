package data
import rl "vendor:raylib"

PlayerInfo :: struct {
    position: rl.Vector2,
    velocity: rl.Vector2,
    direction: Direction,
    animation_progress: f32,
    animation: PlayerAnimation,
}
PlayerAnimation :: enum {
    Idle,
    Run,
}
Direction :: enum {
    Right,
    Left,
}