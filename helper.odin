package game
import rl "vendor:raylib"
import "core:math"

apply_rotation :: proc(p: rl.Vector2, pivot: rl.Vector2, angle: f32) -> rl.Vector2 {
    rad := angle * rl.DEG2RAD
    cos_theta := math.cos(rad)
    sin_theta := math.sin(rad)

    x := p.x - pivot.x
    y := p.y - pivot.y

    rotated_x := x * cos_theta - y * sin_theta
    rotated_y := x * sin_theta + y * cos_theta

    return rl.Vector2{rotated_x + pivot.x, rotated_y + pivot.y}
}
last :: proc(slice: []$T) -> ^T {
    // If the slice is empty, return zero-value of T (avoid out-of-bounds)
    if len(slice) == 0 {
        return nil;   // zero-initialized T
    }
    return &slice[len(slice) - 1];
}
append_array :: proc(array: ^[dynamic]$T, args: [$size]T) {
    for arg in args {
        append(array, arg)
    }
}

Stack :: [dynamic]byte
stack_push :: proc(stack: ^Stack, arg: $T) -> (arg_pointer: int) {
    arg := arg
    for arg_byte in (cast(^[size_of(T)]byte)&arg)^ {
        append(stack, arg_byte)
    }
    return len(stack^) - size_of(T)
}
stack_peek_at :: proc(stack: ^Stack, pointer: int, $type: typeid) -> ^type {
    return cast(^type)&stack[pointer]
}
