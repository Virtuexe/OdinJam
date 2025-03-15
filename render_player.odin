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

ENEMY_TEXTURE_SIZE :: [2]f32{32,32}
ENEMY_SIZE :: [2]f32{32,32}
enemy_texture: [PlayerAnimation]rl.Texture2D = {}
enemy_sound_step: [2]rl.Sound = {}
enemy_texture_slide_count: [PlayerAnimation]int = {
    .Idle = 4,
    .Run = 5,
}
enemy_texture_next_slide_on_progress: [PlayerAnimation]f32 = {
    .Idle = 0.5,
    .Run = 5,
}

render_player_init :: proc() {
    // Load player textures from memory
    player_idle_image := rl.LoadImageFromMemory(".png", raw_data(player_idle_data), i32(len(player_idle_data)))
    player_run_image := rl.LoadImageFromMemory(".png", raw_data(player_run_data), i32(len(player_run_data)))
    
    player_texture[.Idle] = rl.LoadTextureFromImage(player_idle_image)
    player_texture[.Run] = rl.LoadTextureFromImage(player_run_image)
    
    rl.UnloadImage(player_idle_image)
    rl.UnloadImage(player_run_image)

    // Load player sounds from memory
    wave1 := rl.LoadWaveFromMemory(".wav", raw_data(player_step1_data), i32(len(player_step1_data)))
    wave2 := rl.LoadWaveFromMemory(".wav", raw_data(player_step2_data), i32(len(player_step2_data)))
    
    player_sound_step[0] = rl.LoadSoundFromWave(wave1)
    player_sound_step[1] = rl.LoadSoundFromWave(wave2)
    
    rl.UnloadWave(wave1)
    rl.UnloadWave(wave2)
    
    rl.SetSoundVolume(player_sound_step[0], 0.2)
    rl.SetSoundVolume(player_sound_step[1], 0.2)

    // Load enemy textures from memory
    enemy_idle_image := rl.LoadImageFromMemory(".png", raw_data(enemy_idle_data), i32(len(enemy_idle_data)))
    enemy_walk_image := rl.LoadImageFromMemory(".png", raw_data(enemy_walk_data), i32(len(enemy_walk_data)))
    
    enemy_texture[.Idle] = rl.LoadTextureFromImage(enemy_idle_image)
    enemy_texture[.Run] = rl.LoadTextureFromImage(enemy_walk_image)
    
    rl.UnloadImage(enemy_idle_image)
    rl.UnloadImage(enemy_walk_image)

    // Reuse player step sounds for enemy
    enemy_sound_step[0] = player_sound_step[0]
    enemy_sound_step[1] = player_sound_step[1]
    rl.SetSoundVolume(player_sound_step[0], 0.5)
    rl.SetSoundVolume(player_sound_step[1], 0.5)
}
draw_player :: proc(player_info: ^PlayerInfo,
    player_texture: [PlayerAnimation]rl.Texture2D, PLAYER_TEXTURE_SIZE: [2]f32, PLAYER_SIZE: [2]f32, player_texture_next_slide_on_progress: [PlayerAnimation]f32, player_texture_slide_count: [PlayerAnimation]int, 
) {
    if player_info.room_index != game_state.room_index {
        return
    }

    texture_size := PLAYER_TEXTURE_SIZE
    texture_flip_mult:f32 = 1
    if player_info.direction == .Left {
        texture_flip_mult = -1
    }

    ani := player_info.animation
    ani_progress := player_info.animation_progress
    ani_next_slide_on_progress := player_texture_next_slide_on_progress[ani]
    ani_slide_count := player_texture_slide_count[ani]
    slide := int(ani_progress / ani_next_slide_on_progress) % ani_slide_count

    texture_rectangle := rl.Rectangle{f32(texture_size.x) * f32(slide), 0, texture_flip_mult * f32(texture_size.x), f32(texture_size.y)}

    dest_rectangle := rl.Rectangle{
        f32(rl.GetScreenWidth()) / 2 + player_info.position.x * render_get_scale_modifier(),
        f32(rl.GetScreenHeight()) / 2 + player_info.position.y * render_get_scale_modifier(),
        PLAYER_SIZE.x * render_get_scale_modifier(),
        PLAYER_SIZE.y * render_get_scale_modifier()
    }

    origin := PLAYER_SIZE * render_get_scale_modifier() / 2

    rl.DrawTexturePro(player_texture[game_state.player_info.animation], texture_rectangle, dest_rectangle, origin, 0, rl.WHITE)
}