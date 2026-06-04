#!/usr/bin/env python3

# Hex to PSF1 converter
# Because Unscii is offered in hex and I 
# already implemented PSF1
import re

glyphs = {}

with open('./other/unscii.hex') as f:
    for line in f:
        line = line.strip()
        if not line or ':' not in line:
            continue
        codepoint_str, hex_data = line.split(':', 1)
        codepoint = int(codepoint_str, 16)
        hex_data = re.sub(r'[^0-9a-fA-F]', '', hex_data)
        if codepoint < 256 and len(hex_data) >= 32:
            glyphs[codepoint] = bytes.fromhex(hex_data[:32])

with open('./other/unscii.psf', 'wb') as out:
    out.write(bytes([0x36, 0x04, 0x00, 16]))
    for i in range(256):
        out.write(glyphs.get(i, bytes([0] * 16)))
    size = out.tell()

print(f"Wrote {size} bytes")
