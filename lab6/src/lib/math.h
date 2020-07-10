unsigned char bcd_to_num(unsigned char bcd)
{
    return ((bcd & 0xF0) >> 4) * 10 + (bcd & 0x0F);
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