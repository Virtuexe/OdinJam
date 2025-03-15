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

    rl.ClearBackground(rl.BLACK)
    draw_room()
    draw_player()
}

player_animation_passed_slide :: proc(player_anim: PlayerAnimation, on_slide: []i32) -> bool {
    return animation_passed_slide(
        player_info.last_animation_progress, 
        player_info.animation_progress, 
        player_texture_next_slide_on_progress[player_anim],
        i32(player_texture_slide_count[player_anim]),
        on_slide
    )
}
animation_passed_slide :: proc(last_animation_progress: f32, animation_progress: f32, animation_next_slide_limit: f32, slide_count: i32, on_slides: []i32) -> bool {
    last_slide := i32(last_animation_progress / animation_next_slide_limit) % slide_count
    slide := i32(animation_progress / animation_next_slide_limit) % slide_count
    if last_slide == slide {
        return false
    }
    for on_slide in on_slides {
        if slide == on_slide {
            return true
        }
    }
    return false
}