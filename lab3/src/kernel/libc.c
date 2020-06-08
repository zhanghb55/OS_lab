//
//  libc.c
//  Created by zhanghb on 2020/5/1.
//  Copyright © 2020 zhanghb. All rights reserved.
//
#define MaxSize 20

extern void clean();
extern void Poweroff();
extern void Reboot();
extern void putchar(unsigned char c);
extern unsigned char getch();
extern void print_at_point(char buf[16],unsigned int len,unsigned int x,unsigned int y);
extern unsigned char get_number_of_program();
extern unsigned short get_size(unsigned short id);
extern unsigned short get_cylinder(unsigned short id);
extern unsigned short get_head(unsigned short id);
extern unsigned short get_sector(unsigned short id);

extern unsigned char* get_name(unsigned short id);
extern void Run(unsigned short addr,unsigned char cylinder,unsigned char head,unsigned char sector,unsigned short len);
extern unsigned short get_address(unsigned short pid);

extern unsigned char getTime(unsigned char bit);



char strcmp(char* str1, char* str2) {
    int i = 0;
    while (1) {
        if(str1[i]=='\0' || str2[i]=='\0') { break; }
        if(str1[i] != str2[i]) { break; }
        i++;
    }
    return str1[i] - str2[i];
}


unsigned char bcd_to_num(unsigned char bcd)
{
    return ((bcd & 0xF0) >> 4) * 10 + (bcd & 0x0F);
}
int strlen(char*target){
    int count = 0;
    while(target[count] != 0){
        count++;
    }
    return count;
}

void print(char* str) {
    for(int i = 0; i < strlen(str); i++) {
        putchar(str[i]);
    }
}
void get_buf(char*res){
    int i = 0;
    while(1){
        if(i < 0)i = 0;
        char c = getch();
        if(!(c == 0xD || c == '\b' || c >= 32 && c <= 127 || c == '\n'))continue;
        if(i < MaxSize - 1){
            if(c == 0x0D)break;
            else if(c == '\b'){
                putchar('\b');
                putchar(' ');
                putchar('\b');
                i--;
            }
            else{
                putchar(c);
                res[i++] = c;
            }
        }
        //达到了最大值了
        else{
            if(c == 0x0D)break;
            else if(c == '\b'){
                putchar('\b');
                putchar(' ');
                putchar('\b');
                i--;
            }
        }
    }
    res[i] = 0;
    putchar('\r'); 
    putchar('\n');
}


// 转换整数为指定进制的字符串
char* num_to_string(int val, int base) {
    if(val==0) return "0";
    char target[17] = "0123456789ABCDEF";
    static char buf[32] = {0};
    int i = 30;
    for(; val && i ; i--) {
        buf[i] = target[val % base];
        val /= base;
    }
    return &buf[i+1];
}
//将输入的十进制字符串转换为数字
unsigned short string_to_num(char*dec){
    int len = strlen(dec);
    int total = 0;
    for(int i = len - 1,m = 1;i >= 0;i--,m *= 10){
        int bit = dec[i] - '0';
        total += m * bit;
    }
    return total;
}
// 判断字符是否是十进制的正整数
char is_num(char*dec) {
    char flag = 1;
    int len = strlen(dec);
    for(int i = 0;i < len;i++){
        if(!(dec[i] >= '0' && dec[i] <= '9')){
            flag = 0;
            break;
        }
    }
    return flag;
}

//从输入流中截取命令
void get_cmd_from_input(char* str, char* buf) {
    int i = 0;
    while(str[i] && str[i] != ' ') {
        buf[i] = str[i];
        i++;
    }
    buf[i] = '\0'; // 字符串必须以空字符结尾
}

//获取参数列表
void get_argument(char* str, char* buf) {
    buf[0] = '\0';  // 为了应对用户故意搞破坏
    int i = 0;
    while(str[i] && str[i] != ' ') {
        i++;
    }
    while(str[i] && str[i] == ' ') {
        i++;
    }
    int j = 0;
    while(str[i]) {
        buf[j++] = str[i++];
    }
    buf[j] = '\0';  // 字符串必须以空字符结尾
}



/* 打印系统提示符 */
void print_zhb() {
    char* zhb = "zhanghb # ";
    print(zhb);
}
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

void shell(){
    clean();
    show_help();
    char help[10] = "help";
    char ls[10] = "ls";
    char clear[10] = "clear";
    char display[10] = "display";
    char poweroff[10] = "poweroff";
    char reboot[10] = "reboot";
    char time[10] = "time";
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
        else{//命令无效
            char* error = "Invalid command.\r\n";
            print(error);
        }
    } 
}



