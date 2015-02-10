#include <cstdlib>
#include <stdio.h>
#include <iostream>
#include "bytecode.h"

#define MAXSTACKSZ 100

using namespace std;

class VM {
	public:
		// data
		int *code;
		int *stack;
		int *data;
		// registers
		int ip; // instr pointer
		int sp; // stack pointer
		int fp; // frame pointer
		// options
		bool trace;

		VM (int *program, int main, int datasize) : 
				code(program), 
				ip(main),
				data(new int[datasize]), 
				stack(new int[MAXSTACKSZ]),
			 	trace(false) {}

		void cpu() 
		{
			while ( ip < MAXSTACKSZ ) {
				int opcode = code[ip]; // fetch
				ip++; //jump to next instruction or first byte of operand
				switch (opcode) {
					case HALT: { 
						return; 
						break;
					}
					case ICONST: {
						int v = code[ip]; // get next value from code
						ip++;             // increment instruction pointer
						sp++;             // increment stack pointer
						stack[sp] = v;    // push value onto stack
						break;
					}
					case PRINT: {
						int v = stack[sp--]; // get value off stack & decrement stack pointer
						cout << v << endl;   // print value
						break;
					}
					case BR: {
						ip = code[ip++];
						break;
					}
					case IADD: {
						int b = stack[sp--];     // 2nd opnd at top of stack
						int a = stack[sp--];     // 1st opnd 1 below top
						stack[++sp] = a + b; // push result
						break;
					}
					case ISUB: {
						int b = stack[sp--];
						int a = stack[sp--];
						stack[++sp] = a - b;
						break;
					}
					case ILT: {
						int b = stack[sp--];
						int a = stack[sp--];
						stack[++sp] = a < b ? 1 : 0;
						break;
					}
					case IEQ: {
						int b = stack[sp--];
						int a = stack[sp--];
						stack[++sp] = a == b ? 1 : 0;
	 				}
	 				case BRT: {
	 					// branch if true
	 					break;
	 				}
	 				case BRF: {
	 					// branch if fase
	 					break;
	 				}
	 				case LOAD: {
	 					// load from local
	 					break;
	 				}
	 				case GLOAD: {
	 					// load from global
	 					break;
	 				}
	 				case STORE: {
	 					// store in local
	 					break;
	 				}
	 				case POP: {
	 					stack[sp--];
	 					break;
	 				}
					case IMUL: {
						int b = stack[sp--];
						int a = stack[sp--];
						stack[++sp] = a * b;
						break;
					}
				}
			}
		}
};


int main() {
	int program[] = { 
		ICONST, 10,
		ICONST, 15,
		IADD,
		ICONST, 4,
		IMUL,
		PRINT,
		ICONST, 100,
		ICONST, 12,
		ISUB,
		ICONST, 87,
		//IEQ,
		//PRINT,
		ILT,
		PRINT,
		HALT
	};

	VM vm(program, 0, 0);
	vm.cpu();

	return 0;
}

