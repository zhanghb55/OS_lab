#pragma once
#include "system.h"
extern short switchHotwheel();
extern void write_vector(unsigned char a,short ptr);
extern void Timer();

extern void call_int_21h();
extern void call_int_22h();

extern short shutoff();//关闭中断
void write_8(){
    short pos = (int)Timer;
    write_vector(32,pos);
}

void inte(char*user_input){
    char arguments[MaxSize] = {0};
    unsigned short all_id[MaxSize] = {0};
    int count = 0;
    int flag = 1;
    char*target = "21h";
    char*target1 = "22h";
    int flag1 = 0;
    int flag2 = 0;
    for(int i = 0;i < MaxSize;i++){
        get_argument(user_input,arguments);
        char temp[16] = {0};
        get_i_th_argument(arguments,temp,i + 1);
        if(!strcmp(temp,target)){
            flag1 = 1;
        }
        if(!strcmp(temp,target1)){
            flag2 = 1;
        }
        if(temp[0] == 0){
            break;
        }
        if(is_num(temp) == 0){
            flag = 0;
            break;
        }
        all_id[count++] = string_to_num(temp);
    }
    if(flag1 && count == 0){
        shutoff();
        clean();
        call_int_21h();
        clean();
        switchHotwheel();
    }
    else if(flag2 && count == 0){
        shutoff();
        clean();
        call_int_22h();
        clean();
        switchHotwheel();
    }
    else{
        char* error = "Invalid arguments.\r\n";
        print(error);
    }
}