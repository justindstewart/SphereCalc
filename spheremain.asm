;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;Author information
;  Author name: Justin Stewart
;  Author email: scubastew@csu.fullerton.edu
;  Author location: Long Beach, Calif.
;Course information
;  Course number: CPSC240
;  Assignment number: 1
;  Due date: 2015-Aug-25
;Project information
;  Project title: Compute the surface area of a sphere given its radius.
;  Purpose: The purpose of this project is to demonstrate basic functions of assembly programming. Mainly using the integer stack and registers in order to calculate the
;	    surface area and volume of a sphere given a radius. This project also demonstrates the usage of C library standard functions through linking.
;  Status: Executed with no errors.
;  Project files: spheredriver.c, spheremain.asm
;Module information
;  File name: spheremain.asm
;  This module's call name: sphere
;  Language: X86-64
;  Syntax: Intel
;  Date last modified: 2015-Aug-11
;  Purpose: Calculate the surface area and volume of a sphere.
;  Status: Executed with no errors.
;  Future enhancements: None planned.
;Translator information
;  Linux: nasm -f elf64 -l spheremain.lis -o spheremain.o spheremain.asm
;References and credits
;  Holliday, Test Presence of AVX - Project
;  Holliday, Floating Point Input and Ouput - Project
;Format information
;  Page width: 172 columns
;  Begin comments: 61
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;Permission Information
;  This work is private and shall not be posted online, copied or referenced. 
;===== Begin area for source code =========================================================================================================================================

extern printf                                               ;This subprogram will be linked later, used for output

extern scanf						    ;This subprogram will be linked later, used for input
	
global sphere                                               ;Make this program callable by other programs

segment .data                                               ;Initialized data are placed in this segment

;===== Declare some messages ==============================================================================================================================================

welcome db "Welcome to the spheres program. This program will compute the surface area and the volume of a sphere.", 10, 0

prompt db "Please enter the radius of the sphere: ", 0

output db "The sphere with radius %1.18lf has area %1.18lf and volume %1.18lf", 10, 0

farewell db "The main assembly program will now return the surface area to the driver. Enjoy your spheres.", 10, 0

;===== Declare formats for output =========================================================================================================================================

sphere.stringformat db "%s", 0

;===== Declare formats for input ==========================================================================================================================================

sphere.inputformat db "%lf", 0

segment .bss                                                ;Uninitialized data are declared in this segment

;==========================================================================================================================================================================
;===== Begin the application here: Calculate the surface area and volume of a sphere here =================================================================================
;==========================================================================================================================================================================

segment .text                                               ;Instructions are placed in this segment

sphere:                                                     ;Execution of this program will begin here.

;The next two instructions must be performed at the start of every assembly program.
push       rbp                                              ;This marks the start of a new stack frame belonging to this execution of this function.
mov        rbp, rsp                                         ;rbp holds the address of the start of this new stack frame.  When this function returns to its caller rbp must
                                                            ;hold the same value it holds now.

;===== Output the welcome message =========================================================================================================================================
;No important data in registers, therefore printf will be called without backup up any data.

mov  qword rax, 0                                           ;Zero in rax indicates printf receives no data from vector registers
mov        rdi, .stringformat                               ;"%s"
mov        rsi, welcome                                     ;"Welcome to the spheres program. This program will compute the surface area and the volume of a sphere."
call printf                                                 ;An external function handles output

;===== Output the prompt to the user for floating point number ============================================================================================================

mov  qword rax, 0                                           ;Zero in rax indicates printf receives no data from vector registers
mov    	   rdi, .stringformat                               ;"%s"
mov 	   rsi, prompt                                      ;"Please enter the radius of the sphere: "
call printf                                           	    ;An external function handles output

;===== Retrieve radius of sphere from the standard input device and store a copy in xmm3 ==================================================================================

mov  qword rax, 0					    ;Zero in rax indicates scanf receives no data from vector registers
push qword 0						    ;Reserve 8 bytes of storage for the incomming number
mov 	   rdi, .inputformat				    ;"%lf"
mov 	   rsi, rsp					    ;Give scanf a point to the reserved storage
call scanf					    	    ;An external function handles input from user
movsd	   xmm3, [rsp]					    ;Copy the inputted number from integer stack to xmm3
pop	   rax						    ;Make free the storage that was used by scanf

;===== Store a copy of radius from standard input in xmm0, xmm1, and xmm2 =================================================================================================

movsd      xmm0, xmm3					    ;Copy the inputted number to xmm0 for original ouput
movsd      xmm1, xmm3					    ;Copy the inputted number to xmm1 for area calculation/output
movsd      xmm2, xmm3					    ;Copy the inputted number to xmm2 for volume calculation/output

;===== Store the value of (4/3) in xmm13 to be used for calculations ======================================================================================================

mov 	   rax, 0x3ff5555555555555			    ;Constant 0x3ff5555555555555 = (4/3) (decimal)
push       rax						    ;Place the constant on the integer stack
movsd      xmm13, [rsp]					    ;Copy the constant from integer stack to xmm13
pop        rax						    ;Discard the constant

;===== Store the value of (pi) in xmm14 to be used for calculations =======================================================================================================

mov 	   rax, 0x400921fb54442d18			    ;Constant 0x400921fb54442d18 = pi (3.14...)
push 	   rax						    ;Place the constant on the integer stack
movsd      xmm14, [rsp]					    ;Copy the constant from integer stack to xmm14
pop 	   rax						    ;Discard the constant

;===== Store the value of (4.0) in xmm15 to be used for calculations ======================================================================================================

mov 	   rax, 0x4010000000000000			    ;Constant 0x4010000000000000 = 4.0 (decimal)
push 	   rax						    ;Place the constant on the integer stack
movsd      xmm15, [rsp]					    ;Copy the constant from the integer stack to xmm15
pop 	   rax						    ;Discard the constant

;Now the AVX registers used for calculation look approx. like this:
;
;         |-----------------------|
;  ymm15: |  0.0   0.0   0.0  1.55|
;         |-----------------------|
;  ymm14: |  0.0   0.0   0.0  3.14|
;         |-----------------------|
;  ymm13: |  0.0   0.0   0.0  4.0 |
;         |-----------------------|

;===== Calculate area of sphere ===========================================================================================================================================
;4(pi)r^2. Start by multiplying xmm1 by xmm3, which is essentially r^2. Multiply that result xmm1, by the constant 4.0. Multiply that result xmm1, by the constant pi

mulsd 	   xmm1, xmm3					    ;Multiply input by itself - (r^2)
mulsd 	   xmm1, xmm15					    ;Multiply result of squared input by constant 4.0 - (r^2)(4.0)
mulsd 	   xmm1, xmm14					    ;Multiply result by constant pi, surface area of sphere complete and sitting in xmm1 - (r^2)(4.0)(pi)

;===== Calculate volume of sphere =========================================================================================================================================
;(4/3)(pi)r^3. Start by multiplying xmm2 by xmm3 twice, which is essentially r^3. Multiply that result xmm2, by the constant pi. 
;Multiply that result xmm2, by the constant (4/3).

mulsd 	   xmm2, xmm3					    ;Multiply input by itself - (r^2)
mulsd 	   xmm2, xmm3					    ;Multiply result of squared input by input again - r(r^2) = (r^3)
mulsd 	   xmm2, xmm14					    ;Multiply result of cubed input by constant pi - (r^3)(pi)
mulsd 	   xmm2, xmm13					    ;Multiply result by constant (4/3), volume of sphere complete and sitting in xmm2 - (r^3)(pi)(4/3)

;Save a copy of the surface area before calling printf
push qword 0						    ;Reserve 8 bytes of storage 
movsd 	   [rsp], xmm1					    ;Place a backup copy of the surface area in the reserved storage 

;===== Output the calculations ============================================================================================================================================

push 	   qword -1					    ;Off of boundary, Fix by pushing any quadword value.
mov 	   rax, 3					    ;3 floating point numbers will be outputted to user (radius, surface area and volume)
mov 	   rdi, output					    ;"The sphere with radius %1.18lf has area %1.18lf and volume %1.18lf"
call printf						    ;Extern function to print output
pop 	   rax						    ;Reverse the push 4 instructions earlier.

;===== Say farewell =======================================================================================================================================================
;There is one data value on top of the stack that will be used soon, otherwise no need for further backups.

mov  qword rdi, .stringformat                               ;A little good-bye message will be outputted.
mov  qword rsi, farewell                                    ;"The main assembly program will now return the surface area to the driver. Enjoy your spheres."
mov  qword rax, 0                                           ;Zero says that no data values from SSE registers are used by printf
call printf					   	    ;External function to handle output				

;===== Set the value to be returned to the caller =========================================================================================================================
;Presently the value to be returned to the caller is on the top of the system stack.  That value needs to be copied to xmm0 and removed from the stack.

movsd 	   xmm0, [rsp]					    ;A copy of surface area is now in xmm0
pop        rax                                              ;Remove the return value from the stack

pop        rbp                                              ;Restore the value rbp held when this function began execution

;Now the stack is in the same state as when the application area was entered.  It is safe to leave this application area.
;==========================================================================================================================================================================
;===== End of the application: Calculate the surface area and volume of a sphere ==========================================================================================
;==========================================================================================================================================================================

ret                                                         ;Pop an 8-byte integer from the system stack and return to calling function
;===== End of program sphere ==============================================================================================================================================
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

