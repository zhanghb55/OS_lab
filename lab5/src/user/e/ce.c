#include "../../user_lib/stdio.h"

void main(){
    clean();
    char hint0[80] = "Input the character:";
    print(hint0);
    char s = getch();
    putchar(s);
    putchar('\r');
    putchar('\n');
    char hint01[80] = "The character you input is:";
    print(hint01);
    putchar(s);
    putchar('\r');
    putchar('\n');
    char string[MaxSize];
    char hint1[80] = "Input the string:";
    print(hint1);
    get_buf(string);
    char hint11[80] = "The string you input is:";
    print(hint11);
    print(string);
    putchar('\r');
    putchar('\n');
    char hint12[80] = "Press any key to exit.";
    print(hint12);
    s = getch();
    return;
}