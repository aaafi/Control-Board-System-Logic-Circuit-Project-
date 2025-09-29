/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
? Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/27/2025
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega32.h>

// Alphanumeric LCD functions
#include <alcd.h>
#include <stdio.h>
#include <string.h>

// Declare your global variables here
int keypad_touch=0, start=0, t1=0, t2=0, t3=0, counter=0, menu=1, option=1, clc=0, D1=1, D2=1, list=0;
unsigned char keypad[16] = {'7','8','9','/','4','5','6','*','1','2','3','-',' ','0','=','+'};
unsigned char key;
unsigned char password[5];
unsigned char correct_password[5] = "*14/";
unsigned char seven_seg[16] = {
    0x3F, // 0  ->  0011 1111
    0x06, // 1  ->  0000 0110
    0x5B, // 2  ->  0101 1011
    0x4F, // 3  ->  0100 1111
    0x66, // 4  ->  0110 0110
    0x6D, // 5  ->  0110 1101
    0x7D, // 6  ->  0111 1101
    0x07, // 7  ->  0000 0111
    0x7F, // 8  ->  0111 1111
    0x6F, // 9  ->  0110 1111
    0x77, // A  ->  0111 0111
    0x7C, // B  ->  0111 1100
    0x39, // C  ->  0011 1001
    0x5E, // D  ->  0101 1110
    0x79, // E  ->  0111 1001
    0x71  // F  ->  0111 0001
};

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
D2=0;

}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here
// to change the menu
D1=0;
clc=0;
}

// External Interrupt 2 service routine
interrupt [EXT_INT2] void ext_int2_isr(void)
{
keypad_touch++;
key = (PIND >> 4) & 0x0F;

}

// Timer 0 output compare interrupt service routine
interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
// Place your code here
t1++;
t2++;
t3++;

}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out 
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
PIND.3=1;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: CTC top=OCR0
// OC0 output: Disconnected
// Timer Period: 19.968 ms
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (1<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x9B;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: On
// INT2 Mode: Falling Edge
GICR|=(1<<INT1) | (1<<INT0) | (1<<INT2);
MCUCR=(1<<ISC11) | (0<<ISC10) | (1<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(1<<INTF1) | (1<<INTF0) | (1<<INTF2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 1
// EN - PORTB Bit 3
// D4 - PORTB Bit 4
// D5 - PORTB Bit 5
// D6 - PORTB Bit 6
// D7 - PORTB Bit 7
// Characters/line: 16
lcd_init(16);

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here 
      switch (menu){
      case 1: 
      if(t1>49){ 
        t1=0;
        counter++;
        PORTA=seven_seg[counter];
        if(counter==15){    
            counter=0;
        }
      }
      lcd_gotoxy(0,0);
      if(keypad_touch==0){
        lcd_putsf("Please Enter the password"); 
      }
      switch (keypad_touch){
            case 1:    
                if(start==0){
                    lcd_clear();  // Clear LCD line
                    start++;
                }
                password[0]=keypad[key];
                lcd_puts(password);
                break;
            case 2:
                password[1]=keypad[key];
                lcd_puts(password);
                break; 
            case 3:
                password[2]=keypad[key];
                lcd_puts(password);
                break; 
            case 4:
                password[3]=keypad[key];
                lcd_puts(password);
                if(strcmp(password, correct_password) == 0){
                    menu=3;                        
                    PORTA=0x00;
                    counter=0;
                }        
                else{    
                    menu=2; 
                    t2=0;        
                    lcd_clear();
                    lcd_putsf("wrong password");
                }           
                keypad_touch=0;
                start=0;
                memset(password, 0, sizeof(password));  // Fills with null characters
                break;
      }
      break;
      case 2:
        if(t2>49){
            menu=1; 
        } 
        break;
      case 3:
        //taking the switch1 bounce method 1
        if(D1==0){  
            if(PIND.3==0){  
                t3=0; 
                D1=1;
                option++;
                clc=0;
            }  
        }
        else{  
            if(PIND.3==0){
                if(t3>10){ 
                    D1=0;
                }
            }
        }
        //taking the switch2 bounce method 2
        if(D2==0){
            if(PIND.2==0){
                t3=0;
            }
            if(t3>10){
                if(list==0){
                    list=option;
                    clc=0;
                }
                else{ 
                    list=0;
                    PORTC=0x00;
                    PORTA=0x00;
                    clc=0; 
                    counter=0;
                } 
                D2=1;
            }
        } 

        if(list==0){
        if (option>3){   
            option=1;
        } 
        switch (option){ 
            case 1:      
                if(clc==0){ 
                    lcd_clear();
                    clc++;
                }
                lcd_gotoxy(0,0);
                lcd_putsf("Relay <=");
                lcd_gotoxy(0,1);
                lcd_putsf("Buzzer"); 
                break;
            case 2: 
                if(clc==0){ 
                    lcd_clear();
                    clc++;
                }
                lcd_gotoxy(0,0);
                lcd_putsf("Buzzer <=");
                lcd_gotoxy(0,1);
                lcd_putsf("LED"); 
                break;
            case 3: 
                if(clc==0){ 
                    lcd_clear();
                    clc++;
                }
                lcd_gotoxy(0,0);
                lcd_putsf("LED <="); 
                break;
        }
        } 
        else{
            if(clc==0){
                lcd_clear();
                clc++;
            }
            lcd_gotoxy(0,0);
            switch (list){        
                case 1:
                    PORTC.0=1;
                    PORTA=seven_seg[12];
                    lcd_putsf("Relay On");  
                    break;
                case 2:          
                    if(counter==0){
                        t1=0;
                        PORTC.1=1;
                        counter++;
                    }             
                    else{      
                        if(t1>49){
                            PORTC.1=0;
                        }
                    }

                    PORTA=seven_seg[11];
                    lcd_putsf("Buzzer On");
                    break;
                case 3:
                    PORTC.2=1;
                    PORTA=seven_seg[10];
                    lcd_putsf("LED On");
                    break;
            }
        }
        
        
        
      }
      }
}
