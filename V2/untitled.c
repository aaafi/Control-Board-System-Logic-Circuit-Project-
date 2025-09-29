#include <mega32.h>
#include <alcd.h>
#include <stdio.h>
#include <string.h>
#include <delay.h>

// Global variables
int keypad_touch = 0, counter=0, t1=0, t2 = 0, menu = 1, option = 1, clc = 0, D1 = 1, D2 = 1, list = 0, i=0, login_step=0, register_step=0;
unsigned char keypad[16] = {'7', '8', '9', '/', '4', '5', '6', '*', '1', '2', '3', '-', ' ', '0', '=', '+'};
unsigned char key;
unsigned char temp_username[10]={0};
unsigned char temp_password[5]={0};
unsigned char password[5] = {0};
unsigned char correct_password[] = "*14/";
const unsigned char seven_seg[16] = {
    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07,
    0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71
};
typedef struct {
    char username[10];
    unsigned char password_hash[5];
} User;

User users[5];  // Stores up to 5 users
int user_count = 0;

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


void register_user() {
    lcd_gotoxy(0, 0);
    if (keypad_touch == 0) {
        lcd_putsf("Enter Username:");
    } else {
        if (clc == 0) { lcd_clear(); clc = 1; }
        if (keypad[key] == '=' && keypad_touch > 1) {  
            // If space (backspace), remove last character
            temp_username[keypad_touch - 2] = '\0';
            keypad_touch--;
        } else if (keypad_touch <= 9 && keypad[key] != '=') {
            temp_username[keypad_touch - 1] = keypad[key];
        }
        
        lcd_puts(temp_username);

        // Move to password entry when username is complete
        if (keypad_touch == 9 || keypad[key] == '=') {
            keypad_touch = 0;  
            clc = 0;
            register_step=1;
        }
    }
}

void register_password() {
    lcd_gotoxy(0, 0); 
    if (keypad_touch == 0) {
        lcd_putsf("Enter Password:");
    } else {                         
        if (clc == 0) { lcd_clear(); clc = 1; }
        if (keypad[key] == '=' && keypad_touch > 1) {  
            // If space (backspace), remove last character
            temp_password[keypad_touch - 2] = '\0';
            keypad_touch--;
        } else if (keypad_touch <= 4 && keypad[key] != '=') {
            temp_password[keypad_touch - 1] = keypad[key];
        }
        
        lcd_puts(temp_password);  // Show password as entered

        // Finalize registration
        if (keypad_touch == 4 || keypad[key] == '=') {
            strcpy(users[user_count].username, temp_username);
            strcpy(users[user_count].password_hash, temp_password);
            user_count++;
            lcd_clear();
            keypad_touch=0;
            lcd_putsf("User Registered!");  
            memset(temp_username, 0, sizeof(temp_username));
            memset(temp_password, 0, sizeof(temp_password));
            delay_ms(100);
            lcd_clear();
            clc=0;
            menu = 1;  // Go back to menu
        }
    }
}


void login_user() {
    lcd_gotoxy(0, 0);
    // Username input
    if (keypad_touch == 0) {
        lcd_putsf("Enter Username:");
    } else {
        if (clc == 0) { lcd_clear(); clc = 1; }
        if (keypad[key] == '=' && keypad_touch > 1) {  
            // Backspace: Remove last character
            temp_username[keypad_touch - 2] = '\0';
            keypad_touch--;
        } else if (keypad_touch <= 9 && keypad[key] != '=') {
            // Add character
            temp_username[keypad_touch - 1] = keypad[key];
        }
        
        lcd_puts(temp_username);

        // Move to password input when username is complete
        if (keypad_touch == 9 || keypad[key] == '=') {
            keypad_touch = 0;
            clc = 0;
            login_step=1;
        }
    }
}

void login_password() {
    lcd_gotoxy(0, 0);
    // Password input
    if (keypad_touch == 0) {
        lcd_putsf("Enter Password:");
    } else {
        if (clc == 0) { lcd_clear(); clc = 1; }
        if (keypad[key] == '=' && keypad_touch > 1) {  
            // Backspace: Remove last character
            temp_password[keypad_touch - 2] = '\0';
            keypad_touch--;
        } else if (keypad_touch <= 4 && keypad[key] != ' ') {
            // Add character
            temp_password[keypad_touch - 1] = keypad[key];
        }
        
        lcd_puts(temp_password);  // Show password as entered

        // Check credentials when password is complete
        if (keypad_touch == 4 || keypad[key] == '=') {

            for (i = 0; i < user_count; i++) {
                if (strcmp(users[i].username, temp_username) == 0 &&
                    strcmp(users[i].password_hash, temp_password) == 0) {
                    lcd_clear();
                    lcd_putsf("Login Successful!");
                    menu = 3;
                    return;
                }
            }

            lcd_clear();   
            memset(temp_username, 0, sizeof(temp_username));
            memset(temp_password, 0, sizeof(temp_password));
            lcd_putsf("Wrong User/Pass");
            delay_ms(1000);
            menu = 1;
        }
    }
}


void seg_counter(){
    if(t1>5){ 
        t1=0;
        counter++;
        PORTA=seven_seg[counter];
        if(counter==15){    
            counter=0;
        }
      }
}

void bounce1(){
    if(D1==0){  
        if(PIND.3==0){  
            t2=0; 
            D1=1;
            option++;
            clc=0;
        }  
    }
    else{  
        if(PIND.3==0){
            if(t2>2){ 
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
        if(t2>1){
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

void start_menu() {
    lcd_gotoxy(0, 0);
    if (clc == 0) { 
        lcd_clear(); 
        clc = 1; 
    }
    if(option==3){option=1;}
    switch (option) {
        case 1:
            lcd_putsf("Login <=\nRegister");
            break;
        case 2:
            lcd_putsf("Login\nRegister <=");
            break;
    }

    bounce1(); // Change selection
    bounce2(); // Confirm selection

    if (list == 1) {
        menu = 2;  // Move to login step  
        lcd_clear();
        clc=0;      
        list=0;
        login_step = 0;
    } else if (list == 2) {
        menu = 3;  // Move to register step
        lcd_clear();
        clc=0;     
        list=0;
        register_step = 0;
    }
}
void handle_options(){
    lcd_gotoxy(0, 0);
    if (clc == 0) { lcd_clear(); clc = 1; } 
    if(option==4){option=1;}
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
                if(t1>5){
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
            start_menu();
            break;
        case 2:  
            // User selected login 

            if (login_step == 0) {
                login_user();  // Entering username
            } else if (login_step == 1) {
                login_password();  // Entering password
            }
            break;
        case 3:  
            // User selected register 

            if (register_step == 0) {
                register_user();  // Entering username
            } else if (register_step == 1) {
                register_password();  // Entering password
            }
            break;
        case 4:  
            // Logged in - normal menu operations
            bounce1();
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
