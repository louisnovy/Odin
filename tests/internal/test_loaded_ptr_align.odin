package test_internal

import "core:testing"

// A loaded pointer used to be treated as aligned to the load that produced it.
// That is the alignment of where the pointer was stored and not of what it points to.
// With a #min_field_align(16) field, it would use a 16 byte aligned vector load resulting in a fault.

@(test)
test_loaded_ptr_align :: proc(t: ^testing.T) {
	Holder :: struct #min_field_align(16) { v: ^[4]f32 }

	buf: struct #align(16) { pad: f32, v: [4]f32 }
	buf.v = {1, 2, 3, 4}
	h := Holder{&buf.v}
	testing.expect_value(t, h.v^ + h.v^, [4]f32{2, 4, 6, 8})
}
