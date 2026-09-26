package test_issues

import "core:testing"

// Converting to/from a boolean array truncated/extended each element as a vector.
// 256 became false and a payload of 2 was kept as it was.

@(test)
bool_array_cast :: proc(t: ^testing.T) {
	a := [4]i32{0, 1, 256, 2}
	testing.expect_value(t, transmute([4]u8)cast([4]bool)a, [4]u8{0, 1, 1, 1})

	b := transmute([4]b32)[4]u32{0, 1, 256, 2}
	testing.expect_value(t, cast([4]i32)b, [4]i32{0, 1, 1, 1})
}
