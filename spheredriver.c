//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
//Author information
//  Author name: Justin Stewart
//  Author email: scubastew@csu.fullerton.edu
//  Author location: Long Beach, Calif.
//Course information
//  Course number: CPSC240
//  Assignment number: 1
//  Due date: 2015-Aug-25
//Project information
//  Project title: Compute the surface area of a sphere given its radius.
//  Purpose: The purpose of this project is to demonstrate basic functions of assembly programming. Mainly using the integer stack and registers in order to calculate the
//	    surface area and volume of a sphere given a radius. This project also demonstrates the usage of C library standard functions through linking.
//  Status: Executed as expected.
//  Project files: spheredriver.c, spheremain.asm
//Module information
//  File name: spheredriver.c
//  This module's call name: sphere.out  This module is invoked by the user.
//  Language: C
//  Date last modified: 2015-Aug-11
//  Purpose: This module is the top level driver: it will call sphere
//  Status: Executed as expected.
//  Future enhancements: None planned
//Translator information (Tested in Linux shell)
//  Gnu compiler: gcc -c -m64 -Wall -std=c99 -l spheredriver.lis -o spheredriver.o spheredriver.c
//  Gnu linker:   gcc -m64 -o sphere.out spheredriver.o spheremain.o
//  Execute:      ./sphere.out
//References and credits
//  No references: this module is standard C language
//Format information
//  Page width: 172 columns
//  Begin comments: 61
//  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
//
//===== Begin code area ===================================================================================================================================================

#include <stdio.h>
#include <stdint.h>

extern double sphere();

int main()
{
 double return_code=-99.9;
 printf("%s","This is CPSC 240 Assignment 1 programmed by Justin Stewart.\n");
 printf("%s","This software is running on a HP Probook 450 G2 with processor Intel Core i5-5200U running at 2.2GHz.\n");
 return_code = sphere();
 printf("%s %1.18lf\n","The driver received this number: ", return_code);
 printf("%s","The driver program will now return 0 to the operating system.  Have a nice X86 day.\n");
 return 0;
}//End of main

//=======1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
