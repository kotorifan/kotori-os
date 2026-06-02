#!/usr/bin/env python3

# Hex to PSF1 converter
# Because Unscii is offered in hex and I 
# already implemented PSF1
import re

with open('./other/unscii.hex') as f:
    hex_only = re.sub(r'[^0-9a-fA-F]', '', f.read())

hex_only = hex_only[:256 * 16 * 2]

with open('./other/unscii.psf', 'wb') as out:
    out.write(bytes([0x36, 0x04, 0x00, 16]))
    out.write(bytes.fromhex(hex_only))
    out.write(bytes(256 * 16 - out.tell() + 4))

print("Done")
