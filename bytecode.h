#include <cstdlib>
#include <string.h>

using namespace std;

// INSTRUCTION BYTECODES (byte is signed )
const int IADD   = 1;
const int ISUB   = 2; 
const int IMUL   = 3; 
const int ILT    = 4; 
const int IEQ    = 5; 
const int BR     = 6;  // branch
const int BRT    = 7;  // branch if true
const int BRF    = 8;  // branch if false
const int ICONST = 9;  // push constant integer
const int LOAD   = 10; // load from local
const int GLOAD  = 11; // load from global
const int STORE  = 12; // store in local
const int GSTORE = 13; // store in global
const int PRINT  = 14; // print stack top
const int POP    = 15; // throw away top of stack
const int HALT   = 16; // stop execution

class Instruction {
  public:
    Instruction(string _name) : name(_name){}
    Instruction(string _name, int _opnds) : name(_name), opnds(_opnds) {}
    string name;
    int opnds;
};
