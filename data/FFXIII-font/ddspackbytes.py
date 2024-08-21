from sys import argv, stdout
import sys
from struct import pack, unpack
import os
import fileinput
import string

bytes_to_nibble = {
    0x00 : 0x0,
    0x03 : 0x1,
    0x0C : 0x2,
    0x0F : 0x3,
    0x30 : 0x4,
    0x33 : 0x5,
    0x3C : 0x6,
    0x3F : 0x7,
    0xC0 : 0x8,
    0xC3 : 0x9,
    0xCC : 0xA,
    0xCF : 0xB,
    0xF0 : 0xC,
    0xF3 : 0xD,
    0xFC : 0xE,
    0xFF : 0xF,
}

def clearBits(byte):
    if byte & 0xF == 0xF:
        nibble = 0xF
    elif byte & 0xC == 0xC:
        nibble = 0xC
    elif byte & 0x3 == 0x3:
        nibble = 0x3
    else:
        nibble = 0x0
    byte = byte >> 4
    if byte & 0xF == 0xF:
        nibble2 = 0xF
    elif byte & 0xC == 0xC:
        nibble2 = 0xC
    elif byte & 0x3 == 0x3:
        nibble2 = 0x3
    else:
        nibble2 = 0x0
    byte = (nibble2 << 4) | nibble
    return byte
    
def packBytes(outF, byte1, byte2, byte3, byte4, i):
    nibble1 = bytes_to_nibble[byte1]
    nibble2 = bytes_to_nibble[byte2]
    nibble3 = bytes_to_nibble[byte3]
    nibble4 = bytes_to_nibble[byte4]
    
    byte1 = (nibble1 << 4) | nibble2
    byte2 = (nibble3 << 4) | nibble4
    
    outF.seek(i*2)
    enc = pack(">BB", byte1, byte2)
    outF.write(enc)
    return byte1, byte2, enc

def main():
    
    dds = open(argv[1], 'rb')
    outF = open("DebugFontTextureDDS.bin", 'w+b')
    
    for i in xrange(0x10000):
        dds.seek(0x80 + (i*8))
        bytes = unpack(">LBBBB", dds.read(8))
        byte1 = bytes[1]
        byte2 = bytes[2]
        byte3 = bytes[3]
        byte4 = bytes[4]
        
        byte1 = clearBits(byte1)
        byte2 = clearBits(byte2)
        byte3 = clearBits(byte3)
        byte4 = clearBits(byte4)
        
        nByte1, nByte2, enc = packBytes(outF, byte1, byte2, byte3, byte4, i)
    
    outF.close
    print ("%02X %02X %02X %02X" % (byte1, byte2, byte3, byte4))
    print ("%02X %02X" %(nByte1, nByte2))

if __name__ == "__main__":
    main()
