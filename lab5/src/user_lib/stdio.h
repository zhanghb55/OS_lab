#pragma once

#define MaxSize 20

extern void putchar(unsigned char c);
extern unsigned char getch();
extern void print_at_point(char buf[16],unsigned int len,unsigned int x,unsigned int y);
extern void print_pos(char s,int x,int y);
extern void clean();

int _strlen(char*target){
    int count = 0;
    while(target[count] != 0){
        count++;
    }
    return count;
}
void print(char* str) {
    for(int i = 0; i < _strlen(str); i++) {
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

/* 打印系统提示符 */
void print_zhb() {
    char* zhb = "zhanghb # ";
    print(zhb);
}
