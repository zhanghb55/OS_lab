#pragma once
#include "stdio.h"

extern void Poweroff();
extern void Reboot();
extern unsigned char get_number_of_program();
extern unsigned short get_size(unsigned short id);
extern unsigned short get_cylinder(unsigned short id);
extern unsigned short get_head(unsigned short id);
extern unsigned short get_sector(unsigned short id);
extern unsigned char* get_name(unsigned short id);
extern void Run(unsigned short segment,unsigned short addr,unsigned char cylinder,unsigned char head,unsigned char sector,unsigned short len);
extern unsigned short get_address(unsigned short pid);
extern unsigned short get_segment(unsigned short pid);
extern void loadProcessMem(unsigned char cylinder, unsigned char head, unsigned char sector, unsigned short len, unsigned short seg, unsigned short offset, int progid_to_run);
extern unsigned short pflag;

void Delay()
{
	int i = 0;
	int j = 0;
	for( i=0;i<10000;i++ )
		for( j=0;j<10000;j++ )
		{
			j++;
			j--;
		}
}
void get_i_th_argument(char*arguments,char*res,int count){
    int i = 0;
    int ptr = 0;
    int m = 0;
    while(1){
        if(i == count)break;
        if(ptr > strlen(arguments)){
            for(int i = 0;i < strlen(res);i++)res[i] = 0;
            return;
        }
        if(arguments[ptr] != ' ' && arguments[ptr] != 0 && arguments[ptr] != '\t'){
            res[m++] = arguments[ptr++];
        }
        else{
            i++;
            res[m] = 0;
            m = 0;
            while(arguments[ptr] == ' ' || arguments[ptr] == '\t'){
                ptr++;
            }
        }
    }
}
void display_user(char*user_input){
    char arguments[MaxSize] = {0};
    unsigned short all_id[MaxSize] = {0};
    int count = 0;
    int flag = 1;
    for(int i = 0;i < MaxSize;i++){
        get_argument(user_input,arguments);
        char temp[16] = {0};
        get_i_th_argument(arguments,temp,i + 1);
        if(temp[0] == 0){
            break;
        }
        if(is_num(temp) == 0){
            flag = 0;
            break;
        }
        all_id[count++] = string_to_num(temp);
    }
    unsigned short total = get_number_of_program();
    for(int i = 0;i < count;i++){
        if(all_id[i]  > total){
            flag = 0;
        }
    }
    if(flag){
        for(int i = 0;i < count;i++){
            clean();
            char* hint1 = "User Program ";
            char*name = get_name(all_id[i]);
            char* hint2 = " is running,";
            char*hint3 = " press ctrl ";
            char*hint4 = "+ C to exit.\r\n";
            print_at_point(hint1,strlen(hint1),0,0);
            print_at_point(name,strlen(name),0,strlen(hint1));
            print_at_point(hint2,strlen(hint2),0,strlen(hint1) + strlen(name));
            print_at_point(hint3,strlen(hint3),0,strlen(hint1) + strlen(name) + strlen(hint2));
            print_at_point(hint4,strlen(hint4),0,strlen(hint1) + strlen(name) + strlen(hint2) + strlen(hint3));

            Run(get_segment(all_id[i]),get_address(all_id[i]),get_cylinder(all_id[i]),get_head(all_id[i]),get_sector(all_id[i]),get_size(all_id[i])/512);
            clean();
        }
    }
    else{//参数无效
        char* error = "Invalid arguments.\r\n";
        print(error);
    }
}

void parallel_run(char*user_input){
    clean();
    char arguments[MaxSize] = {0};
    unsigned short all_id[MaxSize] = {0};
    int count = 0;
    int flag = 1;
    for(int i = 0;i < MaxSize;i++){
        get_argument(user_input,arguments);
        char temp[16] = {0};
        get_i_th_argument(arguments,temp,i + 1);
        if(temp[0] == 0){
            break;
        }
        if(is_num(temp) == 0){
            flag = 0;
            break;
        }
        all_id[count++] = string_to_num(temp);
    }
    unsigned short total = get_number_of_program();
    for(int i = 0;i < count;i++){
        if(all_id[i]  > 4){
            flag = 0;
        }
    }
    if(flag){
        int i = 0;
        for(int i = 0;i < count;i++){
            int progid_to_run = all_id[i];  // 要运行的用户程序ProgID
            //loadProcessMem(get_address(all_id[i]),get_cylinder(all_id[i]),get_head(all_id[i]),get_sector(all_id[i]),get_size(all_id[i])/512,progid_to_run);                  
            loadProcessMem(get_cylinder(all_id[i]),get_head(all_id[i]), get_sector(all_id[i]), get_size(all_id[i])/512, get_segment(all_id[i]), get_address(all_id[i]), progid_to_run);
        }
        pflag = 1;  // 允许时钟中断处理多进程
        Delay();
        pflag = 0;  // 禁止时钟中断处理多进程
        clean();
    }
    else{//参数无效
        char* error = "Invalid arguments.\r\n";
        print(error);

    }
}