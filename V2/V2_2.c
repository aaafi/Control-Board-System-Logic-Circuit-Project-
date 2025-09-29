#include <mega32.h>
#include <alcd.h>
#include <stdio.h>
#include <string.h>

// Global variables
int keypad_touch = 0, counter=0, t1=0, t2 = 0, menu = 1, option = 1, clc = 0, D1 = 1, D2 = 1, list = 0;
unsigned char keypad[16] = {'7', '8', '9', '/', '4', '5', '6', '*', '1', '2', '3', '-', ' ', '0', '=', '+'};
unsigned char key;
unsigned char password[5] = {0};
unsigned char correct_password[] = "*14/";
const unsigned char seven_seg[16] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07,
    0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71
};

// External Interrupt 0 ISR
interrupt [EXT_INT0] void ext_int0_isr(void) {
    D2 = 0;
}

// External Interrupt 1 ISR
interrupt [EXT_INT1] void ext_int1_isr(void) {
    D1 = 0;
    clc = 0;
}

// External Interrupt 2 ISR (Keypad input)
interrupt [EXT_INT2] void ext_int2_isr(void) {
    keypad_touch++;
    key = (PIND >> 4) & 0x0F;
}

// Timer 0 ISR
interrupt [TIM0_COMP] void timer0_comp_isr(void) {
    t1++;
    t2++;
}

void check_password() {
    if (strcmp(password, correct_password) == 0) {
        menu = 3;  
        counter=0;
        PORTA = 0x00;
    } else {
        menu = 2;
        lcd_clear();
        lcd_putsf("Wrong password");
    }
    keypad_touch = 0;
    clc=0;
    t2=0;
    memset(password, 0, sizeof(password));
}
void seg_counter(){
    if(t1>49){ 
        t1=0;
        counter++;
        PORTA=seven_seg[counter];
        if(counter==15){    
            counter=0;
        }
      }
}
void login(){
    lcd_gotoxy(0, 0);
    if (keypad_touch == 0) {
        lcd_putsf("Enter password:");
    } else {
    if (clc == 0) { lcd_clear(); clc = 1; }
    password[keypad_touch - 1] = keypad[key];
    lcd_puts(password);
    if (keypad_touch == 4){
        password[keypad_touch - 1] = keypad[key];
        check_password(); 
        }
    }
}
void bounce1(){
    if(D1==0){  
        if(PIND.3==0){  
            t2=0; 
            D1=1;
            option++;
            if(option==4){option=1;}
            clc=0;
        }  
    }
    else{  
        if(PIND.3==0){
            if(t2>10){ 
                D1=0;
            }
        }
    }
}
void bounce2(){
    if(D2==0){
        if(PIND.2==0){
            t2=0;
        }
        if(t2>10){
            D2=1;
            if(list==0){
                list=option;
                clc=0;
            }else{ 
                list=0;
                PORTC=0x00;
                PORTA=0x00;
                counter=0;
                clc=0; 
                t2=0;
            } 
        }
    } 
}
void handle_options(){
    lcd_gotoxy(0, 0);
    if (clc == 0) { lcd_clear(); clc = 1; }
    switch(option){
        case 1:
            lcd_putsf("Relay <=\nBuzzer");
            break;
        case 2:
            lcd_putsf("Buzzer <=\nLED");
            break;
        case 3:  
            lcd_putsf("LED <=");
            break;  
    }
}
void handle_list(){
    if (clc == 0) { lcd_clear(); clc = 1; }
    lcd_gotoxy(0, 0);
    switch(list){
        case 1:
            PORTC.0 = 1;
            PORTA = seven_seg[12];
            lcd_putsf("Relay On");
            break;
        case 2: 
            PORTA = seven_seg[11]; 
            lcd_putsf("Buzzer On");
            if(counter==0){
                t1=0;
                PORTC.1=1;
                counter++;
            }else{      
                if(t1>49){
                    PORTC.1=0;
                    }
                }
            break;
        case 3:
            PORTC.2 = 1;
            PORTA = seven_seg[10];
            lcd_putsf("LED On"); 
            break;
    }
}

void handle_menu() {
    switch (menu) {
        case 1:  
            seg_counter();
            login();
            break; 
        case 2:
            if (t2 > 49) menu = 1;
            break;
        case 3:
            //taking the switch1 bounce method 1
            bounce1();
            //taking the switch2 bounce method 2
            bounce2();
            if (list == 0) {
                handle_options();
            } else {
                handle_list();
            }
            break;
    }
}

void main(void) {
    // I/O Port Configuration
    DDRA = 0xFF; PORTA = 0x00;
    DDRB = 0x00; PORTB = 0x00;
    DDRC = 0x07; PORTC = 0x00;
    DDRD = 0x00; PORTD = 0x00;
    PIND=0xFF;

    // Timer Initialization
    TCCR0 = (1 << WGM01) | (1 << CS02) | (1 << CS00);
    OCR0 = 0x9B;
    TIMSK = (1 << OCIE0);

    // External Interrupts
    GICR |= (1 << INT1) | (1 << INT0) | (1 << INT2);
    MCUCR = (1 << ISC11) | (1 << ISC01);
    MCUCSR &= ~(1 << ISC2);

    // LCD Initialization
    lcd_init(16);

    // Enable Global Interrupts
    #asm("sei")

    while (1) {
        handle_menu();
    }
}
