package game
import rl "vendor:raylib"
import fmt "core:fmt"
import "core:math"
import "core:strings"

// Player assets
player_idle_data := #load("assets/Player/Idle.png")
player_run_data := #load("assets/PLayer/Run.png")
player_step1_data := #load("assets/Player/Step1.wav")
player_step2_data := #load("assets/Player/Step2.wav")

// Enemy assets
enemy_idle_data := #load("assets/Monster/Idle.png")
enemy_walk_data := #load("assets/Monster/Walk.png")

// Room assets
room_tiles_data := #load("assets/Room/tiles.png")
room_door_open_data := #load("assets/Room/door_opening.png")
room_door_sound_data := #load("assets/Room/door_opening.mp3")

render_init :: proc() {
    render_player_init()
    render_room_init()
}
render_iter :: proc() {
    rl.BeginDrawing()
    defer rl.EndDrawing()

    rl.ClearBackground(rl.BLACK)
    if game_state.game_over {
        rl.ClearBackground(rl.RED)
    }
    draw_room()
    draw_player(player_info, player_texture, PLAYER_TEXTURE_SIZE, PLAYER_SIZE, player_texture_next_slide_on_progress, player_texture_slide_count)
    draw_player(enemy_info, enemy_texture, ENEMY_TEXTURE_SIZE, ENEMY_SIZE, enemy_texture_next_slide_on_progress, enemy_texture_slide_count)
    if game_state.game_over {
        draw_game_over()
    }
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
draw_game_over :: proc() {
    screen_width := rl.GetScreenWidth()
    screen_height := rl.GetScreenHeight()
    
    // Game over text
    text:cstring = "GAME OVER"
    font_size: i32 = 60
    
    // Calculate text dimensions to center it
    text_width := rl.MeasureText(text, font_size)
    text_x := screen_width/2 - text_width/2
    text_y := screen_height/2 - font_size/2
    
    // Draw text with shadow for better visibility
    rl.DrawText(text, text_x + 3, text_y + 3, font_size, rl.BLACK)  // Shadow
    rl.DrawText(text, text_x, text_y, font_size, rl.WHITE)           // Main text
    
    // Add score text
    score_text := fmt.tprintf("Score: %d", int(game_state.score))
    score_cstr := strings.clone_to_cstring(score_text)
    defer delete(score_cstr)
    
    score_size :i32= 30
    score_width := rl.MeasureText(score_cstr, score_size)
    score_x := screen_width/2 - score_width/2
    score_y := text_y - score_size - 10
    
    rl.DrawText(score_cstr, score_x, score_y, score_size, rl.WHITE)
    
    // Optional: Draw "Press any key to restart" text
    hint_text :cstring= "Press space to restart"
    hint_size :i32= 20
    hint_width := rl.MeasureText(hint_text, hint_size)
    hint_x := screen_width/2 - hint_width/2
    hint_y := text_y + font_size + 20
    
    rl.DrawText(hint_text, hint_x, hint_y, hint_size, rl.WHITE)
}