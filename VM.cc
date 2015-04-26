#include <cstdlib>
#include <iostream>
#include <stdio.h>
#include <climits>
#include <cstring>
#include <cctype>
#include "bytecode.h"

#define MAXSTACKSZ 100

using namespace std;

class VM {
	public:
		int *code;
		int *stack;
		int *data;
		int ip;
		int sp;
		int fp;
		bool trace;

		VM (int *program, int main, int datasize) : 
			code(program), 
			ip(main), 
			data(new int[datasize]), 
			stack(new int[MAXSTACKSZ]), 
			trace(false) {}

		void cpu() {
			while (ip < MAXSTACKSZ) {
				int opcode = code[ip++]; 
				switch (opcode) {
					case HALT: { return; }
					case ICONST: {
						int v = code[ip++];
						stack[++sp] = v;
						break;
					}
					case PRINT: {
						int v = stack[sp--];
						printf("%d", v);    
						break;
					}
					case PRINTLN: {
						int v = stack[sp--];
						printf("%d\n", v);
						break;
					}
					case BR: {
						ip++;
						break;
					}
					case IADD: {
						int b = stack[sp--];
						int a = stack[sp--];
						stack[++sp] = a + b;
						break;
					}
					case ISUB: {
						int b = stack[sp--];
						int a = stack[sp--];
						stack[++sp] = a - b;
						break;
					}
					case IDIV: {
						int b = stack[sp--];
						int a = stack[sp--];
						stack[++sp] = a / b;
						break;
					}
					case IMUL: {
						int b = stack[sp--];
						int a = stack[sp--];
						stack[++sp] = a * b;
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
				}
			}
		}
};


int instruction_from_token(char *nextTok) {
	if (!strcmp(nextTok, "IADD"))    return IADD;
	if (!strcmp(nextTok, "ISUB"))    return ISUB;
	if (!strcmp(nextTok, "IMUL"))    return IMUL;
	if (!strcmp(nextTok, "IDIV"))    return IDIV;
	if (!strcmp(nextTok, "ILT"))     return ILT;
	if (!strcmp(nextTok, "IEQ"))     return IEQ;
	if (!strcmp(nextTok, "BR"))      return BR;
	if (!strcmp(nextTok, "BRT"))     return BRT;
	if (!strcmp(nextTok, "BRF"))     return BRF;
	if (!strcmp(nextTok, "ICONST"))  return ICONST;
	if (!strcmp(nextTok, "LOAD"))    return LOAD;
	if (!strcmp(nextTok, "GLOAD"))   return GLOAD;
	if (!strcmp(nextTok, "STORE"))   return STORE;
	if (!strcmp(nextTok, "GSTORE"))  return GSTORE;
	if (!strcmp(nextTok, "PRINT"))   return PRINT;
	if (!strcmp(nextTok, "PRINTLN")) return PRINTLN;
	if (!strcmp(nextTok, "POP"))     return POP;
	if (!strcmp(nextTok, "HALT"))    return HALT;
	return atoi(nextTok);
}

int main(int argc, char** argv) {
	const char* fileName = argv[1];
	FILE* file = fopen(fileName, "r");
	int* program = new int[256];
	int p = 0;
	char line[256];
	char* nextTok = NULL;

	while (fgets(line, sizeof(line), file)) {
		int len = strlen(line);
		if (len > 0 && line[len-1] == '\n') {
			line[len-1] = '\0';
		}
		nextTok = strtok(line, " ");
		if (nextTok) {
			do {
				program[p++] = instruction_from_token(nextTok);
			} while((nextTok = strtok(NULL, " ")));
		}
	}
	
	fclose(file);
	VM vm(program, 0, 0);
	vm.cpu();
	delete [] program;
	return 0;
}

