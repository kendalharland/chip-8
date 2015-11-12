module Chip8.Instruction where

import Data.Word
import Data.Bits
import Data.Sized.Unsigned

import Chip8.Bits
import Chip8.Memory

data Instruction
  = Rca Address
  | Cls
  | Ret
  | Jmp Address
  | Call Address
  | SkipEqImm Register Immediate
  | SkipNeqImm Register Immediate
  | SkipEqReg Register Register
  | AddImm Register Immediate
  | SetImm Register Immediate
  | SetReg Register Register
  | SetRegOr Register Register
  | SetRegAnd Register Register
  | SetRegXor Register Register
  | SetRegSub Register Register
  | AddReg Register Register
  | SubReg Register Register
  | RShiftReg Register
  | LShiftReg Register
  deriving (Show)

-- Decodes the given opcode and returns the corresponding instruction.
-- Builds upon the example @ github.com/gergoerdi/chip8-haskell.
-- OpCode Listing at: https://en.wikipedia.org/wiki/CHIP-8.
decode :: Word16 -> Instruction
decode opcode = case nibbles of
    (0x0, 0x0, 0xE, 0x0) -> Cls
    (0x0, 0x0, 0xE, 0xE) -> Ret
    (0x0,   _,   _,   _) -> Rca addr
    (0x1,   _,   _,   _) -> Jmp addr
    (0x2,   _,   _,   _) -> Call addr
    (0x3,   x,   _,   _) -> SkipEqImm (Reg x) imm
    (0x4,   x,   _,   _) -> SkipNeqImm (Reg x) imm
    (0x5,   x,   y, 0x0) -> SkipEqReg (Reg x) (Reg y)
    (0x6,   x,   _,   _) -> SetImm (Reg x) imm
    (0x7,   x,   _,   _) -> AddImm (Reg x) imm
    (0x8,   x,   y, 0x0) -> SetReg (Reg x) (Reg y)
    (0x8,   x,   y, 0x1) -> SetRegOr (Reg x) (Reg y)
    (0x8,   x,   y, 0x2) -> SetRegAnd (Reg x) (Reg y)
    (0x8,   x,   y, 0x3) -> SetRegXor (Reg x) (Reg y)
    (0x8,   x,   y, 0x4) -> AddReg (Reg x) (Reg y)
    (0x8,   x,   y, 0x5) -> SubReg (Reg x) (Reg y)
    (0x8,   x,   y, 0x6) -> RShiftReg (Reg x)
    (0x8,   x,   y, 0x7) -> SetRegSub (Reg x) (Reg y)
    (0x8,   x,   y, 0xE) -> LShiftReg (Reg x)
    _                    -> decodeError
  where
    nibbles@(n1, n2, n3, n4) = unpack opcode
    addr = Addr $ pack3 n2 n3 n4
    imm = Imm $ pack2 n3 n4
