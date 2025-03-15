package game
import rl "vendor:raylib"
import fmt "core:fmt"

PLAYER_TEXTURE_SIZE :: [2]f32{16,16}
PLAYER_SIZE :: [2]f32{16,16}
player_texture: [PlayerAnimation]rl.Texture2D = {}
player_sound_step: [2]rl.Sound = {}
player_texture_slide_count: [PlayerAnimation]int = {
    .Idle = 2,
    .Run = 4,
}
player_texture_next_slide_on_progress: [PlayerAnimation]f32 = {
    .Idle = 0.5,
    .Run = 5,
}

render_player_init :: proc() {
    player_texture[.Idle] = rl.LoadTexture("assets/Player/Idle.png")
    player_texture[.Run] = rl.LoadTexture("assets/PLayer/Run.png")

    player_sound_step[0] = rl.LoadSound("assets/Player/Step1.wav")
    player_sound_step[1] = rl.LoadSound("assets/Player/Step2.wav")
    rl.SetSoundVolume(player_sound_step[0], 0.2)
    rl.SetSoundVolume(player_sound_step[1], 0.2)
}
draw_player :: proc() {
    texture_size := PLAYER_TEXTURE_SIZE
    texture_flip_mult:f32 = 1
    if game_state.player_info.direction == .Left {
        texture_flip_mult = -1
    }

    ani := game_state.player_info.animation
    ani_progress := game_state.player_info.animation_progress
    ani_next_slide_on_progress := player_texture_next_slide_on_progress[ani]
    ani_slide_count := player_texture_slide_count[ani]
    slide := int(ani_progress / ani_next_slide_on_progress) % ani_slide_count

    texture_rectangle := rl.Rectangle{f32(texture_size.x) * f32(slide), 0, texture_flip_mult * f32(texture_size.x), f32(texture_size.y)}

    dest_rectangle := rl.Rectangle{
        f32(rl.GetScreenWidth()) / 2 + game_state.player_info.position.x * render_get_scale_modifier(),
        f32(rl.GetScreenHeight()) / 2 + game_state.player_info.position.y * render_get_scale_modifier(),
        PLAYER_SIZE.x * render_get_scale_modifier(),
        PLAYER_SIZE.y * render_get_scale_modifier()
    }

    origin := PLAYER_SIZE * render_get_scale_modifier() / 2

    rl.DrawTexturePro(player_texture[game_state.player_info.animation], texture_rectangle, dest_rectangle, origin, 0, rl.WHITE)
}