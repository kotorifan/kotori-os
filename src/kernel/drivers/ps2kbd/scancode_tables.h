// scancode_tables.h
// Tables for scancodes (as X-macros)
#pragma once

#define DE_SCANCODE_TABLE \
	SCANCODE(0x00, UNKNOWN, 0, 0) \
	SCANCODE(0x1e, A, 'a', 'A') \
	SCANCODE(0x30, B, 'b', 'B') \
	SCANCODE(0x2e, C, 'c', 'C') \
	SCANCODE(0x20, D, 'd', 'D') \
	SCANCODE(0x12, E, 'e', 'E') \
	SCANCODE(0x21, F, 'f', 'F') \
	SCANCODE(0x22, G, 'g', 'G') \
	SCANCODE(0x23, H, 'h', 'H') \
	SCANCODE(0x17, I, 'i', 'I') \
	SCANCODE(0x24, J, 'j', 'J') \
	SCANCODE(0x25, K, 'k', 'K') \
	SCANCODE(0x26, L, 'l', 'L') \
	SCANCODE(0x32, M, 'm', 'M') \
	SCANCODE(0x31, N, 'n', 'N') \
	SCANCODE(0x18, O, 'o', 'O') \
	SCANCODE(0x19, P, 'p', 'P') \
	SCANCODE(0x10, Q, 'q', 'Q') \
	SCANCODE(0x13, R, 'r', 'R') \
	SCANCODE(0x1f, S, 's', 'S') \
	SCANCODE(0x14, T, 't', 'T') \
	SCANCODE(0x16, U, 'u', 'U') \
	SCANCODE(0x2f, V, 'v', 'V') \
	SCANCODE(0x11, W, 'w', 'W') \
	SCANCODE(0x2d, X, 'x', 'X') \
	SCANCODE(0x2c, Y, 'y', 'Y') \
	SCANCODE(0x15, Z, 'z', 'Z') \
	SCANCODE(0x02, K1, '1', '!') \
	SCANCODE(0x03, K2, '2', '"') \
	SCANCODE(0x04, K3, '3', '§') \
	SCANCODE(0x05, K4, '4', '$') \
	SCANCODE(0x06, K5, '5', '%') \
	SCANCODE(0x07, K6, '6', '&') \
	SCANCODE(0x08, K7, '7', '/') \
	SCANCODE(0x09, K8, '8', '(') \
	SCANCODE(0x0a, K9, '9', ')') \
	SCANCODE(0x0b, K0, '0', '=') \
	SCANCODE(0x1a, UE, 'Ü', 'ü') \
	SCANCODE(0x27, OE, 'Ö', 'ö') \
	SCANCODE(0x28, AE, 'Ä', 'ä') \
	SCANCODE(40, RETURN, '\n', '\n') \
	SCANCODE(41, ESCAPE, 0x1B, 0x1B) \
	SCANCODE(42, BACKSPACE, '\b', '\b') \
	SCANCODE(43, TAB, '\t', '\t') \
	SCANCODE(44, SPACE, ' ', ' ') \
	SCANCODE(45, MINUS, '-', '_') \
	SCANCODE(46, EQUALS, '=', '+') \
