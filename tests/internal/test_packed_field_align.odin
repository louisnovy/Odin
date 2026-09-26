package test_internal

import "core:testing"

// A load or store of a field of a #packed struct used to assume the alignment of the field's type:
// a store always, and a load when the field was reached through a nested struct, an array or a global.
// A #simd field then faults on x86, where an aligned vector instruction is used for an unaligned address

@(private="file")
Packed :: struct #packed {
	a:     u8,
	v:     #simd[4]f32,
	inner: struct { v: #simd[4]f32 },
	arr:   [2]#simd[4]f32,
}

@(private="file")
packed_global: struct #align(16) { p: Packed }

// out of line, so the fields really are loaded and stored through `p`
@(private="file")
copy_fields :: #force_no_inline proc "contextless" (p: ^Packed) {
	p.inner.v = p.v
	p.arr[1] = p.inner.v
	packed_global.p.v = p.arr[1]
}

@(test)
test_packed_field_align :: proc(t: ^testing.T) {
	x: struct #align(16) { p: Packed }
	x.p.v = {1, 2, 3, 4}
	copy_fields(&x.p)
	testing.expect_value(t, transmute([4]f32)packed_global.p.v, [4]f32{1, 2, 3, 4})
}
