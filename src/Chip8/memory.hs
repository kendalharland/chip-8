module Chip8.Memory where

import Data.Sized.Unsigned

data Address = Addr U12 deriving (Show)
data Immediate = Imm U8 deriving (Show)
data Register = Reg U4 deriving (Show)
