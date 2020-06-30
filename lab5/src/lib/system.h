#pragma once

extern void Poweroff();
extern void Reboot();
extern unsigned char get_number_of_program();
extern unsigned short get_size(unsigned short id);
extern unsigned short get_cylinder(unsigned short id);
extern unsigned short get_head(unsigned short id);
extern unsigned short get_sector(unsigned short id);
extern unsigned char* get_name(unsigned short id);
extern void Run(unsigned short addr,unsigned char cylinder,unsigned char head,unsigned char sector,unsigned short len);
extern unsigned short get_address(unsigned short pid);