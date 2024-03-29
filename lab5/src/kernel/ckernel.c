#include "../lib/stdio.h"
#include "../lib/string.h"
#include "../lib/time.h"
#include "../lib/interrupt.h"
#include "../lib/system.h"

/* 显示帮助信息 */
void show_help() {
    char *help = 
    "   ZHBOS version 1.0 (x86_16-pc)\r\n"
    "   These shell commands are defined internally.  Type `help' to see this list.\r\n"
    "\r\n"
    "       help - show how to use ZHBOS.\r\n"
    "       clear - empty screen\r\n"
    "       ls - list the user program\r\n"
    "       display <i j> - display user programmes in order, e.g. `display 2 1 3`\r\n"
    "       time - show the current time\r\n"
    "       poweroff - shutdown the machine\r\n"
    "       reboot - restart the machine\r\n"
    "       int - Call interrupt.eg:int 33\r\n"
    "       wheel - turn clock interrupt on or off\r\n"
    "\r\n"
    ;
    print(help);
}



void list_user() {
    unsigned short count = get_number_of_program();
    char* hint = "There are ";
    char*num = num_to_string(count,10);
    char*hint1 = " user programs.\r\n";
    print(hint);
    print(num);
    print(hint1);
    char*hex1 = "0x";
    char*hex2 = "H";
   
    char* list_head =
        "      Name      Size      Address      Cylinder      Head      Sector\r\n";
    char*space6 = "      ";
    char*space7 = "       ";
    char*space8 = "        ";
    char*space9 = "         ";
    char*space10 = "          ";
    print(list_head);

    short prog_num = get_number_of_program();  // 获取用户程序数量
    for(int i = 1; i <= prog_num; i++) {
        print(space7);
        print(get_name(i));
        print(space8);
        
        print(num_to_string(get_size(i), 10));
        print(space7);
        print(hex1);
        print(num_to_string(get_address(i), 16));
        print(hex2);
        print(space10);
        print(num_to_string(get_cylinder(i), 10));
        print(space10);
        print(num_to_string(get_head(i), 10));
        print(space10);
        print(num_to_string(get_sector(i), 10));
        putchar('\r');
        putchar('\n');
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

void kernel(){
    clean();
    show_help();
    char help[10] = "help";
    char ls[10] = "ls";
    char clear[10] = "clear";
    char display[10] = "display";
    char poweroff[10] = "poweroff";
    char reboot[10] = "reboot";
    char time[10] = "time";
    char wheel[10] = "wheel";
    char inter[10] = "int";
    while (1)
    {
        char user_input[MaxSize + 1] = {0};
        char command[MaxSize + 1] = {0};
        print_zhb();
        get_buf(user_input);
        if(strlen(user_input) == 0)continue;
        get_cmd_from_input(user_input,command);

        if(!strcmp(command,help)){
            show_help();
        }
        else if(!strcmp(command,ls)){
            list_user();
        }
        else if(!strcmp(command,clear)){
            clean();
        }
        else if(!strcmp(command,display)){
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

                    Run(get_address(all_id[i]),get_cylinder(all_id[i]),get_head(all_id[i]),get_sector(all_id[i]),get_size(all_id[i])/512);
                    clean();
                }
            }
            else{//参数无效
                char* error = "Invalid arguments.\r\n";
                print(error);

            }
        }
        else if(!strcmp(command,reboot)){
             Reboot();
        }
        else if(!strcmp(command,poweroff)){
             Poweroff();
        }
        else if(!strcmp(command,time)){
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
        else if(strcmp(command, wheel) == 0) {
            char* turned_on = "Hotwheel has been turned on.\r\n";
            char* turned_off = "Hotwheel has been turned off.\r\n";
            if(switchHotwheel()==0) {
                print(turned_off);
            }
            else {
                print(turned_on);
            }
        }
        else if(strcmp(command, inter) == 0){
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
            else if((all_id[0] < 33 || all_id[0] > 36) || count > 1){
                char* error = "Invalid arguments.\r\n";
                print(error);
            }
            else{
                shutoff();
                clean();
                char *hint = "Press Ctrl + C to return from the interrupt.";
                print_at_point(hint,strlen(hint),0,18);
                if(all_id[0] == 33)call_int_33();
                if(all_id[0] == 34)call_int_34();
                if(all_id[0] == 35)call_int_35();
                if(all_id[0] == 36)call_int_36();
                clean();
                switchHotwheel();
            }
        }
        else{//命令无效
            char* error = "Invalid command.\r\n";
            print(error);
        }
    } 
}



