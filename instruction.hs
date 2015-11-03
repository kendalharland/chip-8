module Chip8.Instruction where

import Data.Word

unpack :: Word16 -> (U4, U4, U4, U4)
unpack word = (0xF000 .&. word, 0xF00 .&. word, 0xF0 .&. word, 0xF .&. word)

pack :: (U4, U4, U4, U4) -> Word16
pack (c1, c2, c3, c4) =  

-- Decodes the given opcode and returns the corresponding instruction.
-- Builds upon the example: 
-- https://github.com/gergoerdi/chip8-haskell/blob/master/src/Chip8/OpCode.hs
decode :: Word16 -> Instruction
decode opcode = case chunks of
  -- 0NNN  Calls RCA 1802 program at address NNN.
  -- 00E0  Clears the screen.
  -- 00EE  Returns from a subroutine.
  (0x0,   _,   _,   _) -> Rca addr
  (0x0, 0x0, 0xE, 0x0) -> Cls
  (0x0, 0x0, 0xE, 0xE) -> Ret
  -- 1NNN  Jumps to address NNN 
  (0x1,   _,   _,   _) -> Jmp addr 
  -- 2NNN  Calls Subroutine at NNN
  (0x2,   _,   _,   _) -> Call addr
  -- 3XNN  Skips the next instruction if VX equals NN.
  (0x3,   x,   _,   _) -> SkipEqImm x imm
  -- 4XNN  Skips the next instruction if VX doesn't equal NN.
  (0x4,   x,   _,   _) -> SkipNeqImm x imm
  -- 5XY0  Skips the next instruction if VX equals VY.
  (0x5,   x,   y, 0x0) -> SkipEqReg x y
  -- 6XNN  Sets VX to NN.
  (0x6,   x,   _,   _) -> SetImm x imm
  -- 7XNN  Adds NN to VX.
  (0x7,   x,   _,   _) -> AddImm x imm
  -- 8XY0  Sets VX to the value of VY.
  -- 8XY1  Sets VX to VX or VY.
  -- 8XY2  Sets VX to VX and VY.
  -- 8XY3  Sets VX to VX xor VY.
  -- 8XY4  Adds VY to VX. VF is set to 1 when there's a carry, and to 0 when there isn't.
  -- 8XY5  VY is subtracted from VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
  -- 8XY6  Shifts VX right by one. VF is set to the value of the least significant bit of VX before the shift.[2]
  -- 8XY7  Sets VX to VY minus VX. VF is set to 0 when there's a borrow, and 1 when there isn't.
  -- 8XYE  Shifts VX left by one. VF is set to the value of the most significant bit of VX before the shift.[2]
  -- 9XY0  Skips the next instruction if VX doesn't equal VY.
  -- ANNN  Sets I to the address NNN.
  -- BNNN  Jumps to the address NNN plus V0.
  -- CXNN  Sets VX to the result of a bitwise and operation on a random number and NN.
  -- DXYN  Sprites stored in memory at location in index register (I), 8bits wide. Wraps around the screen. If when drawn, clears a pixel, register VF is set to 1 otherwise it is zero. All drawing is XOR drawing (i.e. it toggles the screen pixels). Sprites are drawn starting at position VX, VY. N is the number of 8bit rows that need to be drawn. If N is greater than 1, second line continues at position VX, VY+1, and so on.
  -- EX9E  Skips the next instruction if the key stored in VX is pressed.
  -- EXA1  Skips the next instruction if the key stored in VX isn't pressed.
  -- FX07  Sets VX to the value of the delay timer.
  -- FX0A  A key press is awaited, and then stored in VX.
  -- FX15  Sets the delay timer to VX.
  -- FX18  Sets the sound timer to VX.
  -- FX1E  Adds VX to I
  -- FX29  Sets I to the location of the sprite for the character in VX
  -- FX33  Stores the Binary-coded decimal representation of VX, with the most significant of three digits at the address in I, the middle digit at I plus 1, and the least significant digit at I plus 2. (In other words, take the decimal representation of VX, place the hundreds digit in memory at location in I, the tens digit at location I+1, and the ones digit at location I+2.)
  -- FX55  Stores V0 to VX in memory starting at address I.[4]
  -- FX65  Fills V0 to VX with values from memory starting at address I.[4]
  where 
    chunks@(c1, c2, c3, c4) = unpack opcode
    addr = Address c2 c3 c4
    imm = Immedate c3 c4

data Instruction 
  -- Todo

