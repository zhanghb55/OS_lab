#pragma once

extern short switchHotwheel();
extern void write_vector(unsigned char a,short ptr);
extern void Timer();
extern void call_int_33();
extern void call_int_34();
extern void call_int_35();
extern void call_int_36();
extern void call_int_21h();
extern void call_int_22h();

extern short shutoff();//关闭中断
void write_8(){
    short pos = (int)Timer;
    write_vector(32,pos);
}
