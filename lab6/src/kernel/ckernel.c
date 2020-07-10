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
    "       display <i j> - display user programs in order, e.g. 'display 2 1 3'\r\n"
    "       time - show the current time\r\n"
    "       poweroff - shutdown the machine\r\n"
    "       reboot - restart the machine\r\n"
    "       int - Call interrupt.eg:int 21h\r\n"
    "       parallel - parallel run the user programs, e.g. 'parallel 1 2 3 4'\r\n"
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
        print(num_to_string(get_address(i) + get_segment(i), 16));
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
    char parallel[10] = "parallel";
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
        else if(!strcmp(command,parallel)){
            parallel_run(user_input);
        }
        else if(!strcmp(command,display)){
            display_user(user_input);
        }
        else if(!strcmp(command,reboot)){
             Reboot();
        }
        else if(!strcmp(command,poweroff)){
             Poweroff();
        }
        else if(!strcmp(command,time)){
            get_time_and_print();
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
            inte(user_input);
        }
        else{//命令无效
            char* error = "Invalid command.\r\n";
            print(error);
        }
    } 
}