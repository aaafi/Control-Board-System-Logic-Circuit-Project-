
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _keypad_touch=R4
	.DEF _keypad_touch_msb=R5
	.DEF _counter=R6
	.DEF _counter_msb=R7
	.DEF _t1=R8
	.DEF _t1_msb=R9
	.DEF _t2=R10
	.DEF _t2_msb=R11
	.DEF _menu=R12
	.DEF _menu_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
	JMP  _ext_int2_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_seven_seg:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F,0x77,0x7C,0x39,0x5E,0x79,0x71
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x1,0x0

_0x3:
	.DB  0x1
_0x4:
	.DB  0x1
_0x5:
	.DB  0x1
_0x6:
	.DB  0x37,0x38,0x39,0x2F,0x34,0x35,0x36,0x2A
	.DB  0x31,0x32,0x33,0x2D,0x20,0x30,0x3D,0x2B
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x55,0x73
	.DB  0x65,0x72,0x6E,0x61,0x6D,0x65,0x3A,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x50,0x61
	.DB  0x73,0x73,0x77,0x6F,0x72,0x64,0x3A,0x0
	.DB  0x55,0x73,0x65,0x72,0x20,0x52,0x65,0x67
	.DB  0x69,0x73,0x74,0x65,0x72,0x65,0x64,0x21
	.DB  0x0,0x4C,0x6F,0x67,0x69,0x6E,0x20,0x53
	.DB  0x75,0x63,0x63,0x65,0x73,0x73,0x66,0x75
	.DB  0x6C,0x21,0x0,0x57,0x72,0x6F,0x6E,0x67
	.DB  0x20,0x55,0x73,0x65,0x72,0x2F,0x50,0x61
	.DB  0x73,0x73,0x0,0x4C,0x6F,0x67,0x69,0x6E
	.DB  0x20,0x3C,0x3D,0xA,0x52,0x65,0x67,0x69
	.DB  0x73,0x74,0x65,0x72,0x0,0x4C,0x6F,0x67
	.DB  0x69,0x6E,0xA,0x52,0x65,0x67,0x69,0x73
	.DB  0x74,0x65,0x72,0x20,0x3C,0x3D,0x0,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x3C,0x3D,0xA
	.DB  0x42,0x75,0x7A,0x7A,0x65,0x72,0x0,0x42
	.DB  0x75,0x7A,0x7A,0x65,0x72,0x20,0x3C,0x3D
	.DB  0xA,0x4C,0x45,0x44,0x0,0x4C,0x45,0x44
	.DB  0x20,0x3C,0x3D,0xA,0x4C,0x6F,0x67,0x20
	.DB  0x4F,0x75,0x74,0x0,0x4C,0x6F,0x67,0x20
	.DB  0x4F,0x75,0x74,0x20,0x3C,0x3D,0x0,0x52
	.DB  0x65,0x6C,0x61,0x79,0x20,0x4F,0x6E,0x0
	.DB  0x42,0x75,0x7A,0x7A,0x65,0x72,0x20,0x4F
	.DB  0x6E,0x0,0x4C,0x45,0x44,0x20,0x4F,0x6E
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _option
	.DW  _0x3*2

	.DW  0x01
	.DW  _D1
	.DW  _0x4*2

	.DW  0x01
	.DW  _D2
	.DW  _0x5*2

	.DW  0x10
	.DW  _keypad
	.DW  _0x6*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <stdio.h>
;#include <string.h>
;
;
;// Global variables
;int keypad_touch = 0, counter=0, t1=0, t2 = 0, menu = 1, option = 1, clc = 0, D1 = 1, D2 = 1, list = 0, i=0, login_step= ...

	.DSEG
;unsigned char keypad[16] = {'7', '8', '9', '/', '4', '5', '6', '*', '1', '2', '3', '-', ' ', '0', '=', '+'};
;unsigned char key;
;unsigned char temp_username[10]={0};
;unsigned char temp_password[5]={0};
;const unsigned char seven_seg[16] = {
;    0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07,
;    0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71
;};
;typedef struct {
;    char username[10];
;    unsigned char password_hash[5];
;} User;
;
;User users[5];  // Stores up to 5 users
;int user_count = 0;
;
;// External Interrupt 0 ISR
;interrupt [EXT_INT0] void ext_int0_isr(void) {
; 0000 001A interrupt [2] void ext_int0_isr(void) {

	.CSEG
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R30
; 0000 001B     D2 = 0;
	LDI  R30,LOW(0)
	STS  _D2,R30
	STS  _D2+1,R30
; 0000 001C }
	RJMP _0x7F
; .FEND
;
;// External Interrupt 1 ISR
;interrupt [EXT_INT1] void ext_int1_isr(void) {
; 0000 001F interrupt [3] void ext_int1_isr(void) {
_ext_int1_isr:
; .FSTART _ext_int1_isr
	ST   -Y,R30
; 0000 0020     D1 = 0;
	LDI  R30,LOW(0)
	STS  _D1,R30
	STS  _D1+1,R30
; 0000 0021     clc = 0;
	CALL SUBOPT_0x0
; 0000 0022 }
_0x7F:
	LD   R30,Y+
	RETI
; .FEND
;
;// External Interrupt 2 ISR (Keypad input)
;interrupt [EXT_INT2] void ext_int2_isr(void) {
; 0000 0025 interrupt [4] void ext_int2_isr(void) {
_ext_int2_isr:
; .FSTART _ext_int2_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0026     keypad_touch++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0027     key = (PIND >> 4) & 0x0F;
	IN   R30,0x10
	LDI  R31,0
	CALL __ASRW4
	ANDI R30,LOW(0xF)
	STS  _key,R30
; 0000 0028 }
	RJMP _0x7E
; .FEND
;
;// Timer 0 ISR
;interrupt [TIM0_COMP] void timer0_comp_isr(void) {
; 0000 002B interrupt [11] void timer0_comp_isr(void) {
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002C     t1++;
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 002D     t2++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 002E }
_0x7E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;void register_user() {
; 0000 0030 void register_user() {
_register_user:
; .FSTART _register_user
; 0000 0031     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1
; 0000 0032     if (keypad_touch == 0) {
	BRNE _0x7
; 0000 0033         lcd_putsf("Enter Username:");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0034     } else {
	RJMP _0x8
_0x7:
; 0000 0035         if (clc == 0) { lcd_clear(); clc = 1; }
	CALL SUBOPT_0x2
	BRNE _0x9
	CALL SUBOPT_0x3
; 0000 0036         if (keypad_touch <= 9 && keypad[key] != '=') {
_0x9:
	CALL SUBOPT_0x4
	BRLT _0xB
	CALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x3D)
	BRNE _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 0037             temp_username[keypad_touch - 1] = keypad[key];
	CALL SUBOPT_0x6
	LD   R30,Z
	ST   X,R30
; 0000 0038         }
; 0000 0039 
; 0000 003A         lcd_puts(temp_username);
_0xA:
	CALL SUBOPT_0x7
; 0000 003B 
; 0000 003C         // Move to password entry when username is complete
; 0000 003D         if (keypad_touch == 9 || keypad[key] == '=') {
	BREQ _0xE
	CALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x3D)
	BRNE _0xD
_0xE:
; 0000 003E             temp_username[keypad_touch - 1] = keypad[key];
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
; 0000 003F             keypad_touch = 0;
; 0000 0040             clc = 0;
; 0000 0041             register_step=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _register_step,R30
	STS  _register_step+1,R31
; 0000 0042         }
; 0000 0043     }
_0xD:
_0x8:
; 0000 0044 }
	RET
; .FEND
;
;void register_password() {
; 0000 0046 void register_password() {
_register_password:
; .FSTART _register_password
; 0000 0047     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1
; 0000 0048     if (keypad_touch == 0) {
	BRNE _0x10
; 0000 0049         lcd_putsf("Enter Password:");
	__POINTW2FN _0x0,16
	CALL _lcd_putsf
; 0000 004A     } else {
	RJMP _0x11
_0x10:
; 0000 004B         if (clc == 0) { lcd_clear(); clc = 1; }
	CALL SUBOPT_0x2
	BRNE _0x12
	CALL SUBOPT_0x3
; 0000 004C         if (keypad_touch <= 4 && keypad[key] != '=') {
_0x12:
	CALL SUBOPT_0x9
	BRLT _0x14
	CALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x3D)
	BRNE _0x15
_0x14:
	RJMP _0x13
_0x15:
; 0000 004D             temp_password[keypad_touch - 1] = keypad[key];
	CALL SUBOPT_0xA
	LD   R30,Z
	ST   X,R30
; 0000 004E         }
; 0000 004F 
; 0000 0050         lcd_puts(temp_password);  // Show password as entered
_0x13:
	CALL SUBOPT_0xB
; 0000 0051         // Finalize registration
; 0000 0052         if (keypad_touch == 4 || keypad[key] == '=') {
	BREQ _0x17
	CALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x3D)
	BRNE _0x16
_0x17:
; 0000 0053             temp_password[keypad_touch - 1] = keypad[key];
	CALL SUBOPT_0xA
	LD   R30,Z
	ST   X,R30
; 0000 0054             strcpy(users[user_count].username, temp_username);
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	CALL _strcpy
; 0000 0055             strcpy(users[user_count].password_hash, temp_password);
	CALL SUBOPT_0xC
	CALL SUBOPT_0xE
	CALL _strcpy
; 0000 0056             user_count++;
	LDI  R26,LOW(_user_count)
	LDI  R27,HIGH(_user_count)
	CALL SUBOPT_0xF
; 0000 0057             keypad_touch=0;
	CLR  R4
	CLR  R5
; 0000 0058             lcd_clear();
	CALL _lcd_clear
; 0000 0059             lcd_putsf("User Registered!");
	__POINTW2FN _0x0,32
	CALL SUBOPT_0x10
; 0000 005A             memset(temp_username, 0, sizeof(temp_username));
; 0000 005B             memset(temp_password, 0, sizeof(temp_password));
; 0000 005C             clc=0;
; 0000 005D             menu=5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	MOVW R12,R30
; 0000 005E             t2=0;
	CLR  R10
	CLR  R11
; 0000 005F         }
; 0000 0060     }
_0x16:
_0x11:
; 0000 0061 }
	RET
; .FEND
;
;
;void login_user() {
; 0000 0064 void login_user() {
_login_user:
; .FSTART _login_user
; 0000 0065     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1
; 0000 0066     // Username input
; 0000 0067     if (keypad_touch == 0) {
	BRNE _0x19
; 0000 0068         lcd_putsf("Enter Username:");
	__POINTW2FN _0x0,0
	CALL _lcd_putsf
; 0000 0069     } else {
	RJMP _0x1A
_0x19:
; 0000 006A         if (clc == 0) { lcd_clear(); clc = 1; }
	CALL SUBOPT_0x2
	BRNE _0x1B
	CALL SUBOPT_0x3
; 0000 006B         if (keypad_touch <= 9 && keypad[key] != '=') {
_0x1B:
	CALL SUBOPT_0x4
	BRLT _0x1D
	CALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x3D)
	BRNE _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 006C             // Add character
; 0000 006D             temp_username[keypad_touch - 1] = keypad[key];
	CALL SUBOPT_0x6
	LD   R30,Z
	ST   X,R30
; 0000 006E         }
; 0000 006F 
; 0000 0070         lcd_puts(temp_username);
_0x1C:
	CALL SUBOPT_0x7
; 0000 0071 
; 0000 0072         // Move to password input when username is complete
; 0000 0073         if (keypad_touch == 9 || keypad[key] == '=') {
	BREQ _0x20
	CALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x3D)
	BRNE _0x1F
_0x20:
; 0000 0074             temp_username[keypad_touch - 1] = keypad[key];
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
; 0000 0075             keypad_touch = 0;
; 0000 0076             clc = 0;
; 0000 0077             login_step=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _login_step,R30
	STS  _login_step+1,R31
; 0000 0078         }
; 0000 0079     }
_0x1F:
_0x1A:
; 0000 007A }
	RET
; .FEND
;
;void login_password() {
; 0000 007C void login_password() {
_login_password:
; .FSTART _login_password
; 0000 007D     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1
; 0000 007E     // Password input
; 0000 007F     if (keypad_touch == 0) {
	BRNE _0x22
; 0000 0080         lcd_putsf("Enter Password:");
	__POINTW2FN _0x0,16
	CALL _lcd_putsf
; 0000 0081     } else {
	RJMP _0x23
_0x22:
; 0000 0082         if (clc == 0) { lcd_clear(); clc = 1; }
	CALL SUBOPT_0x2
	BRNE _0x24
	CALL SUBOPT_0x3
; 0000 0083         if (keypad_touch <= 4 && keypad[key] != ' ') {
_0x24:
	CALL SUBOPT_0x9
	BRLT _0x26
	CALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x20)
	BRNE _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 0084             // Add character
; 0000 0085             temp_password[keypad_touch - 1] = keypad[key];
	CALL SUBOPT_0xA
	LD   R30,Z
	ST   X,R30
; 0000 0086         }
; 0000 0087 
; 0000 0088         lcd_puts(temp_password);  // Show password as entered
_0x25:
	CALL SUBOPT_0xB
; 0000 0089 
; 0000 008A         // Check credentials when password is complete
; 0000 008B         if (keypad_touch == 4 || keypad[key] == '=') {
	BREQ _0x29
	CALL SUBOPT_0x5
	LD   R26,Z
	CPI  R26,LOW(0x3D)
	BREQ _0x29
	RJMP _0x28
_0x29:
; 0000 008C             temp_password[keypad_touch - 1] = keypad[key];
	CALL SUBOPT_0xA
	LD   R30,Z
	ST   X,R30
; 0000 008D             for (i = 0; i < user_count; i++) {
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x2C:
	LDS  R30,_user_count
	LDS  R31,_user_count+1
	CALL SUBOPT_0x11
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x2D
; 0000 008E                 if (strcmp(users[i].username, temp_username) == 0 &&
; 0000 008F                     strcmp(users[i].password_hash, temp_password) == 0) {
	CALL SUBOPT_0x11
	LDI  R30,LOW(15)
	CALL __MULB1W2U
	CALL SUBOPT_0xD
	CALL _strcmp
	CPI  R30,0
	BRNE _0x2F
	CALL SUBOPT_0x11
	LDI  R30,LOW(15)
	CALL __MULB1W2U
	CALL SUBOPT_0xE
	CALL _strcmp
	CPI  R30,0
	BREQ _0x30
_0x2F:
	RJMP _0x2E
_0x30:
; 0000 0090                     lcd_clear();
	CALL _lcd_clear
; 0000 0091                     counter=0;
	CLR  R6
	CLR  R7
; 0000 0092                     PORTA = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0093                     lcd_putsf("Login Successful!");
	__POINTW2FN _0x0,49
	CALL SUBOPT_0x10
; 0000 0094                     memset(temp_username, 0, sizeof(temp_username));
; 0000 0095                     memset(temp_password, 0, sizeof(temp_password));
; 0000 0096                     clc=0;
; 0000 0097                     lcd_clear();
	CALL _lcd_clear
; 0000 0098                     menu=6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x2080003
; 0000 0099                     t2=0;
; 0000 009A                     return;
; 0000 009B                 }
; 0000 009C             }
_0x2E:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	CALL SUBOPT_0xF
	RJMP _0x2C
_0x2D:
; 0000 009D 
; 0000 009E             lcd_clear();
	CALL _lcd_clear
; 0000 009F             memset(temp_username, 0, sizeof(temp_username));
	LDI  R30,LOW(_temp_username)
	LDI  R31,HIGH(_temp_username)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
; 0000 00A0             memset(temp_password, 0, sizeof(temp_password));
	LDI  R30,LOW(_temp_password)
	LDI  R31,HIGH(_temp_password)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _memset
; 0000 00A1             lcd_putsf("Wrong User/Pass");
	__POINTW2FN _0x0,67
	CALL _lcd_putsf
; 0000 00A2             clc=0;
	CALL SUBOPT_0x0
; 0000 00A3             keypad_touch=0;
	CLR  R4
	CLR  R5
; 0000 00A4             login_step=0;
	LDI  R30,LOW(0)
	STS  _login_step,R30
	STS  _login_step+1,R30
; 0000 00A5             menu=7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
_0x2080003:
	MOVW R12,R30
; 0000 00A6             t2=0;
	CLR  R10
	CLR  R11
; 0000 00A7             return;
	RET
; 0000 00A8         }
; 0000 00A9     }
_0x28:
_0x23:
; 0000 00AA }
	RET
; .FEND
;
;
;void seg_counter(){
; 0000 00AD void seg_counter(){
_seg_counter:
; .FSTART _seg_counter
; 0000 00AE     if(t1>49){
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x31
; 0000 00AF         t1=0;
	CLR  R8
	CLR  R9
; 0000 00B0         counter++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 00B1         PORTA=seven_seg[counter];
	SUBI R30,LOW(-_seven_seg*2)
	SBCI R31,HIGH(-_seven_seg*2)
	LPM  R0,Z
	OUT  0x1B,R0
; 0000 00B2         if(counter==15){
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x32
; 0000 00B3             counter=0;
	CLR  R6
	CLR  R7
; 0000 00B4         }
; 0000 00B5       }
_0x32:
; 0000 00B6 }
_0x31:
	RET
; .FEND
;
;void bounce1(){
; 0000 00B8 void bounce1(){
_bounce1:
; .FSTART _bounce1
; 0000 00B9     if(D1==0){
	LDS  R30,_D1
	LDS  R31,_D1+1
	SBIW R30,0
	BRNE _0x33
; 0000 00BA         if(PIND.3==0){
	SBIC 0x10,3
	RJMP _0x34
; 0000 00BB             t2=0;
	CLR  R10
	CLR  R11
; 0000 00BC             D1=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _D1,R30
	STS  _D1+1,R31
; 0000 00BD             option++;
	LDI  R26,LOW(_option)
	LDI  R27,HIGH(_option)
	CALL SUBOPT_0xF
; 0000 00BE             clc=0;
	CALL SUBOPT_0x0
; 0000 00BF         }
; 0000 00C0     }
_0x34:
; 0000 00C1     else{
	RJMP _0x35
_0x33:
; 0000 00C2         if(PIND.3==0){
	SBIC 0x10,3
	RJMP _0x36
; 0000 00C3             if(t2>20){
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x37
; 0000 00C4                 D1=0;
	LDI  R30,LOW(0)
	STS  _D1,R30
	STS  _D1+1,R30
; 0000 00C5             }
; 0000 00C6         }
_0x37:
; 0000 00C7     }
_0x36:
_0x35:
; 0000 00C8 }
	RET
; .FEND
;void bounce2(){
; 0000 00C9 void bounce2(){
_bounce2:
; .FSTART _bounce2
; 0000 00CA     if(D2==0){
	LDS  R30,_D2
	LDS  R31,_D2+1
	SBIW R30,0
	BRNE _0x38
; 0000 00CB         if(PIND.2==0){
	SBIC 0x10,2
	RJMP _0x39
; 0000 00CC             t2=0;
	CLR  R10
	CLR  R11
; 0000 00CD         }
; 0000 00CE         if(t2>10){
_0x39:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x3A
; 0000 00CF             D2=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _D2,R30
	STS  _D2+1,R31
; 0000 00D0             if(list==0){
	CALL SUBOPT_0x12
	SBIW R30,0
	BRNE _0x3B
; 0000 00D1                 list=option;
	CALL SUBOPT_0x13
	STS  _list,R30
	STS  _list+1,R31
; 0000 00D2                 clc=0;
	CALL SUBOPT_0x0
; 0000 00D3             }else{
	RJMP _0x3C
_0x3B:
; 0000 00D4                 list=0;
	CALL SUBOPT_0x14
; 0000 00D5                 PORTC=0x00;
	OUT  0x15,R30
; 0000 00D6                 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00D7                 counter=0;
	CLR  R6
	CLR  R7
; 0000 00D8                 clc=0;
	CALL SUBOPT_0x0
; 0000 00D9                 t2=0;
	CLR  R10
	CLR  R11
; 0000 00DA             }
_0x3C:
; 0000 00DB         }
; 0000 00DC     }
_0x3A:
; 0000 00DD }
_0x38:
	RET
; .FEND
;
;void start_menu() {
; 0000 00DF void start_menu() {
_start_menu:
; .FSTART _start_menu
; 0000 00E0     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x15
; 0000 00E1     bounce1(); // Change selection
	RCALL _bounce1
; 0000 00E2     bounce2(); // Confirm selection
	RCALL _bounce2
; 0000 00E3     if (clc == 0) {
	CALL SUBOPT_0x2
	BRNE _0x3D
; 0000 00E4         lcd_clear();
	CALL SUBOPT_0x3
; 0000 00E5         clc = 1;
; 0000 00E6     }
; 0000 00E7     if(option==3){option=1;}
_0x3D:
	LDS  R26,_option
	LDS  R27,_option+1
	SBIW R26,3
	BRNE _0x3E
	CALL SUBOPT_0x16
; 0000 00E8     switch (option) {
_0x3E:
	CALL SUBOPT_0x13
; 0000 00E9         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x42
; 0000 00EA             lcd_putsf("Login <=\nRegister");
	__POINTW2FN _0x0,83
	RJMP _0x7C
; 0000 00EB             break;
; 0000 00EC         case 2:
_0x42:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x41
; 0000 00ED             lcd_putsf("Login\nRegister <=");
	__POINTW2FN _0x0,101
_0x7C:
	CALL _lcd_putsf
; 0000 00EE             break;
; 0000 00EF     }
_0x41:
; 0000 00F0 
; 0000 00F1     if (list == 1) {
	LDS  R26,_list
	LDS  R27,_list+1
	SBIW R26,1
	BRNE _0x44
; 0000 00F2         menu = 2;  // Move to login step
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R12,R30
; 0000 00F3         lcd_clear();
	RCALL _lcd_clear
; 0000 00F4         clc=0;
	CALL SUBOPT_0x0
; 0000 00F5         list=0;
	CALL SUBOPT_0x14
; 0000 00F6         login_step = 0;
	STS  _login_step,R30
	STS  _login_step+1,R30
; 0000 00F7     } else if (list == 2) {
	RJMP _0x45
_0x44:
	LDS  R26,_list
	LDS  R27,_list+1
	SBIW R26,2
	BRNE _0x46
; 0000 00F8         menu = 3;  // Move to register step
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R12,R30
; 0000 00F9         lcd_clear();
	RCALL _lcd_clear
; 0000 00FA         clc=0;
	CALL SUBOPT_0x0
; 0000 00FB         list=0;
	CALL SUBOPT_0x14
; 0000 00FC         register_step = 0;
	STS  _register_step,R30
	STS  _register_step+1,R30
; 0000 00FD     }
; 0000 00FE }
_0x46:
_0x45:
	RET
; .FEND
;void handle_options(){
; 0000 00FF void handle_options(){
_handle_options:
; .FSTART _handle_options
; 0000 0100     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x15
; 0000 0101     if (clc == 0) { lcd_clear(); clc = 1; }
	CALL SUBOPT_0x2
	BRNE _0x47
	CALL SUBOPT_0x3
; 0000 0102     if(option==5){option=1;}
_0x47:
	LDS  R26,_option
	LDS  R27,_option+1
	SBIW R26,5
	BRNE _0x48
	CALL SUBOPT_0x16
; 0000 0103     switch(option){
_0x48:
	CALL SUBOPT_0x13
; 0000 0104         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x4C
; 0000 0105             lcd_putsf("Relay <=\nBuzzer");
	__POINTW2FN _0x0,119
	RJMP _0x7D
; 0000 0106             break;
; 0000 0107         case 2:
_0x4C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x4D
; 0000 0108             lcd_putsf("Buzzer <=\nLED");
	__POINTW2FN _0x0,135
	RJMP _0x7D
; 0000 0109             break;
; 0000 010A         case 3:
_0x4D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x4E
; 0000 010B             lcd_putsf("LED <=\nLog Out");
	__POINTW2FN _0x0,149
	RJMP _0x7D
; 0000 010C             break;
; 0000 010D         case 4:
_0x4E:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4B
; 0000 010E             lcd_putsf("Log Out <=");
	__POINTW2FN _0x0,164
_0x7D:
	RCALL _lcd_putsf
; 0000 010F     }
_0x4B:
; 0000 0110 }
	RET
; .FEND
;void handle_list(){
; 0000 0111 void handle_list(){
_handle_list:
; .FSTART _handle_list
; 0000 0112     if (clc == 0) { lcd_clear(); clc = 1; }
	CALL SUBOPT_0x2
	BRNE _0x50
	CALL SUBOPT_0x3
; 0000 0113     lcd_gotoxy(0, 0);
_0x50:
	CALL SUBOPT_0x15
; 0000 0114     switch(list){
	CALL SUBOPT_0x12
; 0000 0115         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x54
; 0000 0116             PORTC.0 = 1;
	SBI  0x15,0
; 0000 0117             PORTA = seven_seg[12];
	__POINTW1FN _seven_seg,12
	LPM  R0,Z
	OUT  0x1B,R0
; 0000 0118             lcd_putsf("Relay On");
	__POINTW2FN _0x0,175
	RCALL _lcd_putsf
; 0000 0119             break;
	RJMP _0x53
; 0000 011A         case 2:
_0x54:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x57
; 0000 011B             PORTA = seven_seg[11];
	__POINTW1FN _seven_seg,11
	LPM  R0,Z
	OUT  0x1B,R0
; 0000 011C             lcd_putsf("Buzzer On");
	__POINTW2FN _0x0,184
	RCALL _lcd_putsf
; 0000 011D             if(counter==0){
	MOV  R0,R6
	OR   R0,R7
	BRNE _0x58
; 0000 011E                 t1=0;
	CLR  R8
	CLR  R9
; 0000 011F                 PORTC.1=1;
	SBI  0x15,1
; 0000 0120                 counter++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0121             }else{
	RJMP _0x5B
_0x58:
; 0000 0122                 if(t1>49){
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	CP   R30,R8
	CPC  R31,R9
	BRGE _0x5C
; 0000 0123                     PORTC.1=0;
	CBI  0x15,1
; 0000 0124                     }
; 0000 0125                 }
_0x5C:
_0x5B:
; 0000 0126             break;
	RJMP _0x53
; 0000 0127         case 3:
_0x57:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5F
; 0000 0128             PORTC.2 = 1;
	SBI  0x15,2
; 0000 0129             PORTA = seven_seg[10];
	__POINTW1FN _seven_seg,10
	LPM  R0,Z
	OUT  0x1B,R0
; 0000 012A             lcd_putsf("LED On");
	__POINTW2FN _0x0,194
	RCALL _lcd_putsf
; 0000 012B             break;
	RJMP _0x53
; 0000 012C         case 4:
_0x5F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x53
; 0000 012D             menu=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 012E             clc=0;
	CALL SUBOPT_0x0
; 0000 012F             keypad_touch=0;
	CLR  R4
	CLR  R5
; 0000 0130             counter=0;
	CLR  R6
	CLR  R7
; 0000 0131             option=1;
	CALL SUBOPT_0x16
; 0000 0132             list=0;
	LDI  R30,LOW(0)
	STS  _list,R30
	STS  _list+1,R30
; 0000 0133             break;
; 0000 0134     }
_0x53:
; 0000 0135 }
	RET
; .FEND
;
;void handle_menu() {
; 0000 0137 void handle_menu() {
_handle_menu:
; .FSTART _handle_menu
; 0000 0138     switch (menu) {
	MOVW R30,R12
; 0000 0139         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x66
; 0000 013A             seg_counter();
	RCALL _seg_counter
; 0000 013B             start_menu();
	RCALL _start_menu
; 0000 013C             break;
	RJMP _0x65
; 0000 013D         case 2:
_0x66:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x67
; 0000 013E             // User selected login
; 0000 013F             seg_counter();
	RCALL _seg_counter
; 0000 0140             if (login_step == 0) {
	LDS  R30,_login_step
	LDS  R31,_login_step+1
	SBIW R30,0
	BRNE _0x68
; 0000 0141                 login_user();  // Entering username
	RCALL _login_user
; 0000 0142             } else if (login_step == 1) {
	RJMP _0x69
_0x68:
	LDS  R26,_login_step
	LDS  R27,_login_step+1
	SBIW R26,1
	BRNE _0x6A
; 0000 0143                 login_password();  // Entering password
	RCALL _login_password
; 0000 0144             }
; 0000 0145             break;
_0x6A:
_0x69:
	RJMP _0x65
; 0000 0146         case 3:
_0x67:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6B
; 0000 0147             // User selected register
; 0000 0148             seg_counter();
	RCALL _seg_counter
; 0000 0149             if (register_step == 0) {
	LDS  R30,_register_step
	LDS  R31,_register_step+1
	SBIW R30,0
	BRNE _0x6C
; 0000 014A                 register_user();  // Entering username
	RCALL _register_user
; 0000 014B             } else if (register_step == 1) {
	RJMP _0x6D
_0x6C:
	LDS  R26,_register_step
	LDS  R27,_register_step+1
	SBIW R26,1
	BRNE _0x6E
; 0000 014C                 register_password();  // Entering password
	RCALL _register_password
; 0000 014D             }
; 0000 014E             break;
_0x6E:
_0x6D:
	RJMP _0x65
; 0000 014F         case 4:
_0x6B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x6F
; 0000 0150             // Logged in - normal menu operations
; 0000 0151             bounce1();
	RCALL _bounce1
; 0000 0152             bounce2();
	RCALL _bounce2
; 0000 0153             if (list == 0) {
	CALL SUBOPT_0x12
	SBIW R30,0
	BRNE _0x70
; 0000 0154                 handle_options();
	RCALL _handle_options
; 0000 0155             } else {
	RJMP _0x71
_0x70:
; 0000 0156                 handle_list();
	RCALL _handle_list
; 0000 0157             }
_0x71:
; 0000 0158             break;
	RJMP _0x65
; 0000 0159         case 5:
_0x6F:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x72
; 0000 015A             // Register Sucessful
; 0000 015B             if (t2 > 49) menu = 1;
	CALL SUBOPT_0x17
	BRGE _0x73
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 015C             break;
_0x73:
	RJMP _0x65
; 0000 015D         case 6:
_0x72:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x74
; 0000 015E             // Login Sucessful
; 0000 015F             if (t2 > 49) menu = 4;
	CALL SUBOPT_0x17
	BRGE _0x75
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R12,R30
; 0000 0160             break;
_0x75:
	RJMP _0x65
; 0000 0161         case 7:
_0x74:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x65
; 0000 0162             // wrong user_pass
; 0000 0163             if (t2 > 49) menu = 1;
	CALL SUBOPT_0x17
	BRGE _0x77
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
; 0000 0164             break;
_0x77:
; 0000 0165     }
_0x65:
; 0000 0166 }
	RET
; .FEND
;
;
;void main(void) {
; 0000 0169 void main(void) {
_main:
; .FSTART _main
; 0000 016A     // I/O Port Configuration
; 0000 016B     DDRA = 0xFF; PORTA = 0x00;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 016C     DDRB = 0x00; PORTB = 0x00;
	OUT  0x17,R30
	OUT  0x18,R30
; 0000 016D     DDRC = 0x07; PORTC = 0x00;
	LDI  R30,LOW(7)
	OUT  0x14,R30
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 016E     DDRD = 0x00; PORTD = 0x00;
	OUT  0x11,R30
	OUT  0x12,R30
; 0000 016F     PIND=0xFF;
	LDI  R30,LOW(255)
	OUT  0x10,R30
; 0000 0170 
; 0000 0171     // Timer Initialization
; 0000 0172     TCCR0 = (1 << WGM01) | (1 << CS02) | (1 << CS00);
	LDI  R30,LOW(13)
	OUT  0x33,R30
; 0000 0173     OCR0 = 0x9B;
	LDI  R30,LOW(155)
	OUT  0x3C,R30
; 0000 0174     TIMSK = (1 << OCIE0);
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0175 
; 0000 0176     // External Interrupts
; 0000 0177     GICR |= (1 << INT1) | (1 << INT0) | (1 << INT2);
	IN   R30,0x3B
	ORI  R30,LOW(0xE0)
	OUT  0x3B,R30
; 0000 0178     MCUCR = (1 << ISC11) | (1 << ISC01);
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0179     MCUCSR &= ~(1 << ISC2);
	IN   R30,0x34
	ANDI R30,0xBF
	OUT  0x34,R30
; 0000 017A 
; 0000 017B     // LCD Initialization
; 0000 017C     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 017D 
; 0000 017E     // Enable Global Interrupts
; 0000 017F     #asm("sei")
	sei
; 0000 0180 
; 0000 0181     while (1) {
_0x78:
; 0000 0182         handle_menu();
	RCALL _handle_menu
; 0000 0183     }
	RJMP _0x78
; 0000 0184 }
_0x7B:
	RJMP _0x7B
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x18
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x18,R30
	__DELAY_USB 13
	SBI  0x18,3
	__DELAY_USB 13
	CBI  0x18,3
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x18
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x18
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2080001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RJMP _0x2080002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x17
	ORI  R30,LOW(0xF0)
	OUT  0x17,R30
	SBI  0x17,3
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,3
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x19
	CALL SUBOPT_0x19
	CALL SUBOPT_0x19
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
	ADIW R28,5
	RET
; .FEND
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND

	.CSEG

	.DSEG
_option:
	.BYTE 0x2
_clc:
	.BYTE 0x2
_D1:
	.BYTE 0x2
_D2:
	.BYTE 0x2
_list:
	.BYTE 0x2
_i:
	.BYTE 0x2
_login_step:
	.BYTE 0x2
_register_step:
	.BYTE 0x2
_keypad:
	.BYTE 0x10
_key:
	.BYTE 0x1
_temp_username:
	.BYTE 0xA
_temp_password:
	.BYTE 0x5
_users:
	.BYTE 0x4B
_user_count:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	STS  _clc,R30
	STS  _clc+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	MOV  R0,R4
	OR   R0,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2:
	LDS  R30,_clc
	LDS  R31,_clc+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x3:
	CALL _lcd_clear
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _clc,R30
	STS  _clc+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x5:
	LDS  R30,_key
	LDI  R31,0
	SUBI R30,LOW(-_keypad)
	SBCI R31,HIGH(-_keypad)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x6:
	MOVW R30,R4
	SBIW R30,1
	SUBI R30,LOW(-_temp_username)
	SBCI R31,HIGH(-_temp_username)
	MOVW R26,R30
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_temp_username)
	LDI  R27,HIGH(_temp_username)
	CALL _lcd_puts
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LD   R30,Z
	ST   X,R30
	CLR  R4
	CLR  R5
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	MOVW R30,R4
	SBIW R30,1
	SUBI R30,LOW(-_temp_password)
	SBCI R31,HIGH(-_temp_password)
	MOVW R26,R30
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_temp_password)
	LDI  R27,HIGH(_temp_password)
	CALL _lcd_puts
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDS  R26,_user_count
	LDS  R27,_user_count+1
	LDI  R30,LOW(15)
	CALL __MULB1W2U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	SUBI R30,LOW(-_users)
	SBCI R31,HIGH(-_users)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_temp_username)
	LDI  R27,HIGH(_temp_username)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	__ADDW1MN _users,10
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_temp_password)
	LDI  R27,HIGH(_temp_password)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x10:
	CALL _lcd_putsf
	LDI  R30,LOW(_temp_username)
	LDI  R31,HIGH(_temp_username)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _memset
	LDI  R30,LOW(_temp_password)
	LDI  R31,HIGH(_temp_password)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _memset
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDS  R30,_list
	LDS  R31,_list+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDS  R30,_option
	LDS  R31,_option+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	STS  _list,R30
	STS  _list+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _option,R30
	STS  _option+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	CP   R30,R10
	CPC  R31,R11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ASRW4:
	ASR  R31
	ROR  R30
__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

;END OF CODE MARKER
__END_OF_CODE:
