//
//  count.c
//  Created by zhanghb on 2020/5/7.
//  Copyright © 2020 zhanghb. All rights reserved.
//

extern void clean();
extern void putchar(unsigned char c);


int count(char*target){
    int count = 0;
    int total = 0;
    while(target[count] != 0){
        count++;
	if(target[count] == 'a')total++;
    }
    return total;
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

int fun(char*s){
clean();
    int len = count(s);
    char*hint1 = "The string \"";
    char*hint2 = "\" has ";
    print(hint1);
    print(s);
    print(hint2);
    return len;
}

