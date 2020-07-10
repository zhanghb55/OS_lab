#pragma once

#include "stdio.h"
#include "math.h"
#include "string.h"
extern unsigned char getTime(unsigned char bit);
void print_time(){
    unsigned char year = getTime(9);
    unsigned char month = getTime(8);
    unsigned char day = getTime(7);
    unsigned char hour = getTime(4);
    unsigned char min = getTime(2);
    unsigned char sec = getTime(0);
    char time[32];
    for(int i = 0;i < 32;i++)time[i] = 0;
    add_char(time,'2');
    add_char(time,'0');
    Splicing_string(time,num_to_string(bcd_to_num(year),10));
    add_char(time,'-');
    Splicing_string(time,num_to_string(bcd_to_num(month),10));
    add_char(time,'-');
    Splicing_string(time,num_to_string(bcd_to_num(day),10));
    add_char(time,' ');
    add_char(time,' ');
    Splicing_string(time,num_to_string(bcd_to_num(hour),10));
    add_char(time,':');
    Splicing_string(time,num_to_string(bcd_to_num(min),10));
    add_char(time,':');
    Splicing_string(time,num_to_string(bcd_to_num(sec),10));
    for(int i = 0;i < 21;i++){
        print_pos(time[i],24,i + 50);
    }
    
    return;
}

void get_time_and_print(){
    unsigned char year = getTime(9);
    unsigned char month = getTime(8);
    unsigned char day = getTime(7);
    unsigned char hour = getTime(4);
    unsigned char min = getTime(2);
    unsigned char sec = getTime(0);
    putchar('2');
    putchar('0');
    print(num_to_string(bcd_to_num(year),10));
    putchar('-');
    print(num_to_string(bcd_to_num(month),10));
    putchar('-');
    print(num_to_string(bcd_to_num(day),10));
    putchar(' ');putchar(' ');
    print(num_to_string(bcd_to_num(hour),10));
    putchar(':');
    print(num_to_string(bcd_to_num(min),10));
    putchar(':');
    print(num_to_string(bcd_to_num(sec),10));
    putchar('\r'); 
    putchar('\n');
}