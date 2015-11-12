module Chip8.Bits where

import Data.Bits
import Data.Sized.Unsigned
import Data.Word

-- Unpacks a 16-bit word into a set of four nibbles.
unpack :: Word16 -> (U4, U4, U4, U4)
unpack word = (fromIntegral $ (shiftR word 12) .&. 0xF
              ,fromIntegral $ (shiftR word  8) .&. 0xF
              ,fromIntegral $ (shiftR word  4) .&. 0xF
              ,fromIntegral $ word .&. 0xF)

-- Packs 3 nibbles into 12-bit word
pack3 :: U4 -> U4 -> U4 -> U12
pack3 x y z =  sum [fromIntegral $ shiftL x 8
                   ,fromIntegral $ shiftL y 4
                   ,fromIntegral $ z]

-- Packs 2 nibbles into a byte
pack2 :: U4 -> U4 -> U8
pack2 x y = sum [fromIntegral $ shiftL x 4, fromIntegral y]
