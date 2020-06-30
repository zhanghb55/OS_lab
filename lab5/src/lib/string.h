#pragma once
int strlen(char*target){
    int count = 0;
    while(target[count] != 0){
        count++;
    }
    return count;
}

char strcmp(char* str1, char* str2) {
    int i = 0;
    while (1) {
        if(str1[i]=='\0' || str2[i]=='\0') { break; }
        if(str1[i] != str2[i]) { break; }
        i++;
    }
    return str1[i] - str2[i];
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
//把src的字符拼到target后面
void Splicing_string(char*target,char*src){
    int len1 = strlen(target);
    int len2 = strlen(src);
    for(int i = 0;i < len2;i++){
        target[i + len1] = src[i];
    }
}
//给字符串添加字符
void add_char(char*target,char src){
    int len = strlen(target);
    target[len] = src;
}