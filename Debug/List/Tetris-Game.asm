
;CodeVisionAVR C Compiler V4.02 
;(C) Copyright 1998-2024 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega164A
;Program type           : Application
;Clock frequency        : 20.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega164A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC

	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPMCSR=0x37
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40
	.EQU __EEPROM_PAGE_SIZE=0x04

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

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
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

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
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

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
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
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
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
	.DEF _nPosX=R3
	.DEF _nPosX_msb=R4
	.DEF _nPosY=R5
	.DEF _nPosY_msb=R6
	.DEF _nGetNextPiece=R8
	.DEF _GameOver=R7

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
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

_mTetromino:
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x3:
	.DB  0x9,0x0,0x9,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x9,0x0,0x9,0x0
	.DB  0x9,0x0,0x9,0x0,0x9,0x0,0x9
_0x0:
	.DB  0x49,0x6E,0x76,0x61,0x6C,0x69,0x64,0x20
	.DB  0x63,0x6F,0x6D,0x6D,0x61,0x6E,0x64,0x21
	.DB  0xA,0x0,0x47,0x61,0x6D,0x65,0x20,0x4F
	.DB  0x76,0x65,0x72,0x21,0xA,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x07
	.DW  __REG_VARS*2

	.DW  0xEF
	.DW  _mMatrix
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

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
	OUT  MCUCR,R31
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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

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
	.ORG 0x00

	.DSEG
	.ORG 0x200

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.DSEG
;void mAssignTetromino(int Index) {
; 0000 0050 void mAssignTetromino(int Index) {

	.CSEG
_mAssignTetromino:
; .FSTART _mAssignTetromino
; 0000 0051 int i, j;
; 0000 0052 for (i = 0; i < 4; i++) {
	RCALL __SAVELOCR6
	MOVW R20,R26
;	Index -> R20,R21
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x5:
	__CPWRN 16,17,4
	BRGE _0x6
; 0000 0053 for (j = 0; j < 4; j++) {
	__GETWRN 18,19,0
_0x8:
	__CPWRN 18,19,4
	BRGE _0x9
; 0000 0054 mCurrentPiece[i][j] = mTetromino[Index][i][j];
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	LSL  R30
	ROL  R31
	RCALL __LSLW4
	SUBI R30,LOW(-_mTetromino*2)
	SBCI R31,HIGH(-_mTetromino*2)
	MOVW R26,R30
	MOVW R30,R16
	RCALL __LSLW3
	RCALL SUBOPT_0x2
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0000 0055 }
	__ADDWRN 18,19,1
	RJMP _0x8
_0x9:
; 0000 0056 }
	__ADDWRN 16,17,1
	RJMP _0x5
_0x6:
; 0000 0057 }
	RJMP _0x20A0003
; .FEND
;void mPlacePiece(){
; 0000 005A void mPlacePiece(){
_mPlacePiece:
; .FSTART _mPlacePiece
; 0000 005B int i, j;
; 0000 005C for(i = 0; i < 4; i++){
	RCALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0xB:
	__CPWRN 16,17,4
	BRGE _0xC
; 0000 005D for(j = 0; j < 4; j++){
	__GETWRN 18,19,0
_0xE:
	__CPWRN 18,19,4
	BRGE _0xF
; 0000 005E if(mCurrentPiece[i][j] == 1){ //Place rewrite cell only if its 0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x3
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x10
; 0000 005F mMatrix[nPosX + i][nPosY + j] = mCurrentPiece[i][j];
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0060 }
; 0000 0061 }
_0x10:
	__ADDWRN 18,19,1
	RJMP _0xE
_0xF:
; 0000 0062 }
	__ADDWRN 16,17,1
	RJMP _0xB
_0xC:
; 0000 0063 }
	RJMP _0x20A0001
; .FEND
;void mRemovePiece(){
; 0000 0066 void mRemovePiece(){
_mRemovePiece:
; .FSTART _mRemovePiece
; 0000 0067 int i, j;
; 0000 0068 for(i = 0; i < 4; i++){
	RCALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x12:
	__CPWRN 16,17,4
	BRGE _0x13
; 0000 0069 for(j = 0; j < 4; j++){
	__GETWRN 18,19,0
_0x15:
	__CPWRN 18,19,4
	BRGE _0x16
; 0000 006A if(mCurrentPiece[i][j] == 1) { //Place rewrite cell only if its 0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x3
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x17
; 0000 006B mMatrix[nPosX + i][nPosY + j] = 0;
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x6
; 0000 006C }
; 0000 006D }
_0x17:
	__ADDWRN 18,19,1
	RJMP _0x15
_0x16:
; 0000 006E }
	__ADDWRN 16,17,1
	RJMP _0x12
_0x13:
; 0000 006F }
	RJMP _0x20A0001
; .FEND
;void mLockPiece(){
; 0000 0072 void mLockPiece(){
_mLockPiece:
; .FSTART _mLockPiece
; 0000 0073 mPlacePiece();
	RCALL _mPlacePiece
; 0000 0074 nGetNextPiece = true;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0075 }
	RET
; .FEND
;void mRotate(int direction) {
; 0000 0078 void mRotate(int direction) {
_mRotate:
; .FSTART _mRotate
; 0000 0079 int temp[4][4];
; 0000 007A int i, j;
; 0000 007B 
; 0000 007C // Rotate right (clockwise)
; 0000 007D if (direction == 1) {
	SBIW R28,32
	RCALL __SAVELOCR6
	MOVW R20,R26
;	direction -> R20,R21
;	temp -> Y+6
;	i -> R16,R17
;	j -> R18,R19
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x18
; 0000 007E for (i = 0; i < 4; i++) {
	__GETWRN 16,17,0
_0x1A:
	__CPWRN 16,17,4
	BRGE _0x1B
; 0000 007F for (j = 0; j < 4; j++) {
	__GETWRN 18,19,0
_0x1D:
	__CPWRN 18,19,4
	BRGE _0x1E
; 0000 0080 temp[j][3 - i] = mCurrentPiece[i][j];
	MOVW R30,R18
	RCALL __LSLW3
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	SUB  R30,R16
	SBC  R31,R17
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0081 }
	__ADDWRN 18,19,1
	RJMP _0x1D
_0x1E:
; 0000 0082 }
	__ADDWRN 16,17,1
	RJMP _0x1A
_0x1B:
; 0000 0083 }
; 0000 0084 // Rotate left (counterclockwise)
; 0000 0085 else if (direction == -1) {
	RJMP _0x1F
_0x18:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x20
; 0000 0086 for (i = 0; i < 4; i++) {
	__GETWRN 16,17,0
_0x22:
	__CPWRN 16,17,4
	BRGE _0x23
; 0000 0087 for (j = 0; j < 4; j++) {
	__GETWRN 18,19,0
_0x25:
	__CPWRN 18,19,4
	BRGE _0x26
; 0000 0088 temp[3 - j][i] = mCurrentPiece[i][j];
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	SUB  R30,R18
	SBC  R31,R19
	RCALL __LSLW3
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R16
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0089 }
	__ADDWRN 18,19,1
	RJMP _0x25
_0x26:
; 0000 008A }
	__ADDWRN 16,17,1
	RJMP _0x22
_0x23:
; 0000 008B }
; 0000 008C 
; 0000 008D // Copy the result back to McurrentPiece
; 0000 008E for (i = 0; i < 4; i++) {
_0x20:
_0x1F:
	__GETWRN 16,17,0
_0x28:
	__CPWRN 16,17,4
	BRGE _0x29
; 0000 008F for (j = 0; j < 4; j++) {
	__GETWRN 18,19,0
_0x2B:
	__CPWRN 18,19,4
	BRGE _0x2C
; 0000 0090 mCurrentPiece[i][j] = temp[i][j];
	RCALL SUBOPT_0x0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R16
	RCALL __LSLW3
	MOVW R26,R28
	ADIW R26,6
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 0091 }
	__ADDWRN 18,19,1
	RJMP _0x2B
_0x2C:
; 0000 0092 }
	__ADDWRN 16,17,1
	RJMP _0x28
_0x29:
; 0000 0093 }
	RCALL __LOADLOCR6
	ADIW R28,38
	RET
; .FEND
;void mPrintMatrix(){
; 0000 0096 void mPrintMatrix(){
_mPrintMatrix:
; .FSTART _mPrintMatrix
; 0000 0097 int i, j;
; 0000 0098 for(i = 0; i < 8; i++){
	RCALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x2E:
	__CPWRN 16,17,8
	BRGE _0x2F
; 0000 0099 PORTA = ~(1 << i);
	MOV  R30,R16
	LDI  R26,LOW(1)
	RCALL __LSLB12
	COM  R30
	OUT  0x2,R30
; 0000 009A PORTB = 0x00;
	LDI  R30,LOW(0)
	OUT  0x5,R30
; 0000 009B for(j = 2; j < 10; j++){
	__GETWRN 18,19,2
_0x31:
	__CPWRN 18,19,10
	BRGE _0x32
; 0000 009C PORTB |= mMatrix[i][j] << j-2;
	IN   R22,5
	RCALL SUBOPT_0x7
	LD   R26,X
	MOV  R30,R18
	SUBI R30,LOW(2)
	RCALL __LSLB12
	OR   R30,R22
	OUT  0x5,R30
; 0000 009D }
	__ADDWRN 18,19,1
	RJMP _0x31
_0x32:
; 0000 009E delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
; 0000 009F }
	__ADDWRN 16,17,1
	RJMP _0x2E
_0x2F:
; 0000 00A0 }
	RJMP _0x20A0001
; .FEND
;_Bool mDoesPieceFit() {
; 0000 00A3 _Bool mDoesPieceFit() {
_mDoesPieceFit:
; .FSTART _mDoesPieceFit
; 0000 00A4 int i, j, boardX, boardY;
; 0000 00A5 for (i = 0; i < 4; i++) {
	SBIW R28,2
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	boardX -> R20,R21
;	boardY -> Y+6
	__GETWRN 16,17,0
_0x34:
	__CPWRN 16,17,4
	BRGE _0x35
; 0000 00A6 for (j = 0; j < 4; j++) {
	__GETWRN 18,19,0
_0x37:
	__CPWRN 18,19,4
	BRGE _0x38
; 0000 00A7 // Skip if the block in the piece is empty
; 0000 00A8 if (mCurrentPiece[i][j] == 0) {
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x8
	BREQ _0x36
; 0000 00A9 continue;
; 0000 00AA }
; 0000 00AB 
; 0000 00AC boardX = nPosX + i;
	MOVW R30,R16
	ADD  R30,R3
	ADC  R31,R4
	MOVW R20,R30
; 0000 00AD boardY = nPosY + j;
	MOVW R30,R18
	ADD  R30,R5
	ADC  R31,R6
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 00AE 
; 0000 00AF // Ensure that the block is within the board boundaries
; 0000 00B0 if (boardX < 0 || boardX >= 10 || boardY < 0 || boardY >= 12) {
	TST  R21
	BRMI _0x3B
	__CPWRN 20,21,10
	BRGE _0x3B
	LDD  R26,Y+7
	TST  R26
	BRMI _0x3B
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,12
	BRLT _0x3A
_0x3B:
; 0000 00B1 return false;
	LDI  R30,LOW(0)
	RJMP _0x20A0004
; 0000 00B2 }
; 0000 00B3 
; 0000 00B4 // If the block is outside the playable 8x8 area or it overlaps with any non-zero value in the board
; 0000 00B5 if (mMatrix[boardX][boardY] != 0) {
_0x3A:
	RCALL SUBOPT_0x9
	MOVW R26,R30
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x8
	BREQ _0x3D
; 0000 00B6 return false;
	LDI  R30,LOW(0)
	RJMP _0x20A0004
; 0000 00B7 }
; 0000 00B8 }
_0x3D:
_0x36:
	__ADDWRN 18,19,1
	RJMP _0x37
_0x38:
; 0000 00B9 }
	__ADDWRN 16,17,1
	RJMP _0x34
_0x35:
; 0000 00BA return true;
	LDI  R30,LOW(1)
_0x20A0004:
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
; 0000 00BB }
; .FEND
;void mPieceMove(int nDirection){
; 0000 00BE void mPieceMove(int nDirection){
_mPieceMove:
; .FSTART _mPieceMove
; 0000 00BF mRemovePiece();
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	nDirection -> R16,R17
	RCALL _mRemovePiece
; 0000 00C0 nPosY += nDirection;
	__ADDWRR 5,6,16,17
; 0000 00C1 if(mDoesPieceFit()){ // If the new position is valid, move
	RCALL _mDoesPieceFit
	CPI  R30,0
	BRNE _0x81
; 0000 00C2 mPlacePiece();
; 0000 00C3 }else{ // If not then return to last position
; 0000 00C4 nPosY -= nDirection;
	__SUBWRR 5,6,16,17
; 0000 00C5 mPlacePiece();
_0x81:
	RCALL _mPlacePiece
; 0000 00C6 }
; 0000 00C7 }
	RJMP _0x20A0002
; .FEND
;void mPushPieceDown() {
; 0000 00CA void mPushPieceDown() {
_mPushPieceDown:
; .FSTART _mPushPieceDown
; 0000 00CB mRemovePiece();
	RCALL _mRemovePiece
; 0000 00CC nPosX++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
; 0000 00CD if (mDoesPieceFit() == true) {
	RCALL _mDoesPieceFit
	CPI  R30,LOW(0x1)
	BRNE _0x40
; 0000 00CE mPlacePiece();
	RCALL _mPlacePiece
; 0000 00CF } else {
	RJMP _0x41
_0x40:
; 0000 00D0 nPosX--;  // Revert the move
	__GETW1R 3,4
	SBIW R30,1
	__PUTW1R 3,4
; 0000 00D1 mPlacePiece();  // Place the piece back
	RCALL _mPlacePiece
; 0000 00D2 mLockPiece();  // Lock the piece in place
	RCALL _mLockPiece
; 0000 00D3 }
_0x41:
; 0000 00D4 }
	RET
; .FEND
;void mGetUserInput(int input){
; 0000 00D7 void mGetUserInput(int input){
_mGetUserInput:
; .FSTART _mGetUserInput
; 0000 00D8 switch (input) {
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	input -> R16,R17
	MOVW R30,R16
; 0000 00D9 case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x45
; 0000 00DA mPieceMove(-1);
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	RCALL _mPieceMove
; 0000 00DB break;
	RJMP _0x44
; 0000 00DC case 2:
_0x45:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x46
; 0000 00DD mPieceMove(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _mPieceMove
; 0000 00DE break;
	RJMP _0x44
; 0000 00DF case 3:
_0x46:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x47
; 0000 00E0 mRemovePiece();
	RCALL _mRemovePiece
; 0000 00E1 mRotate(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _mRotate
; 0000 00E2 if(!mDoesPieceFit()){
	RCALL _mDoesPieceFit
	CPI  R30,0
	BRNE _0x48
; 0000 00E3 mRotate(-1);
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	RCALL _mRotate
; 0000 00E4 }
; 0000 00E5 mPlacePiece();
_0x48:
	RCALL _mPlacePiece
; 0000 00E6 break;
	RJMP _0x44
; 0000 00E7 case 4:
_0x47:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x4A
; 0000 00E8 mPushPieceDown();
	RCALL _mPushPieceDown
; 0000 00E9 break;
	RJMP _0x44
; 0000 00EA default:
_0x4A:
; 0000 00EB printf("Invalid command!\n");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0xA
; 0000 00EC break;
; 0000 00ED }
_0x44:
; 0000 00EE }
	RJMP _0x20A0002
; .FEND
;void mClearFullRows() {
; 0000 00F1 void mClearFullRows() {
_mClearFullRows:
; .FSTART _mClearFullRows
; 0000 00F2 int i, j, k;
; 0000 00F3 // Loop through each row from the second last row (index 7) to the top row (index 0)
; 0000 00F4 for (i = 7; i >= 0; i--) {
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
	__GETWRN 16,17,7
_0x4C:
	TST  R17
	BRPL PC+2
	RJMP _0x4D
; 0000 00F5 bool isFull = true;
; 0000 00F6 // Check if the row is full, ignoring the left and right borders
; 0000 00F7 for (j = 1; j < 9; j++) {
	SBIW R28,1
	LDI  R30,LOW(1)
	ST   Y,R30
;	isFull -> Y+0
	__GETWRN 18,19,1
_0x4F:
	__CPWRN 18,19,9
	BRGE _0x50
; 0000 00F8 if (mMatrix[i][j] == 0) {
	RCALL SUBOPT_0x7
	__GETW1P
	SBIW R30,0
	BRNE _0x51
; 0000 00F9 isFull = false;
	LDI  R30,LOW(0)
	ST   Y,R30
; 0000 00FA break;
	RJMP _0x50
; 0000 00FB }
; 0000 00FC }
_0x51:
	__ADDWRN 18,19,1
	RJMP _0x4F
_0x50:
; 0000 00FD // If the row is full, clear it and shift everything above it down
; 0000 00FE if (isFull) {
	LD   R30,Y
	CPI  R30,0
	BREQ _0x52
; 0000 00FF // Clear Row and print ===============
; 0000 0100 for (j = 2; j < 10; j++) {
	__GETWRN 18,19,2
_0x54:
	__CPWRN 18,19,10
	BRGE _0x55
; 0000 0101 k = i;
	MOVW R20,R16
; 0000 0102 mMatrix[k][j] = 0;
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x6
; 0000 0103 }
	__ADDWRN 18,19,1
	RJMP _0x54
_0x55:
; 0000 0104 mPrintMatrix();
	RCALL _mPrintMatrix
; 0000 0105 // Shift all rows above the current one down
; 0000 0106 for (k = i; k > 0; k--) {
	MOVW R20,R16
_0x57:
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRGE _0x58
; 0000 0107 for (j = 2; j < 10; j++) {
	__GETWRN 18,19,2
_0x5A:
	__CPWRN 18,19,10
	BRGE _0x5B
; 0000 0108 mMatrix[k][j] = mMatrix[k - 1][j];
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x1
	SBIW R30,1
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RCALL __MULW12U
	SUBI R30,LOW(-_mMatrix)
	SBCI R31,HIGH(-_mMatrix)
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x3
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
; 0000 0109 }
	__ADDWRN 18,19,1
	RJMP _0x5A
_0x5B:
; 0000 010A }
	__SUBWRN 20,21,1
	RJMP _0x57
_0x58:
; 0000 010B // Clear the top row after shifting
; 0000 010C for (j = 2; j < 10; j++) {
	__GETWRN 18,19,2
_0x5D:
	__CPWRN 18,19,10
	BRGE _0x5E
; 0000 010D mMatrix[0][j] = 0;
	MOVW R30,R18
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x6
; 0000 010E }
	__ADDWRN 18,19,1
	RJMP _0x5D
_0x5E:
; 0000 010F // Since the current row has been cleared, check the same row again
; 0000 0110 i++;
	__ADDWRN 16,17,1
; 0000 0111 }
; 0000 0112 }
_0x52:
	ADIW R28,1
	__SUBWRN 16,17,1
	RJMP _0x4C
_0x4D:
; 0000 0113 }
_0x20A0003:
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;int mGetRandomTetrominoIndex() {
; 0000 0116 int mGetRandomTetrominoIndex() {
_mGetRandomTetrominoIndex:
; .FSTART _mGetRandomTetrominoIndex
; 0000 0117 return rand() % 7;
	RCALL _rand
	MOVW R26,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RCALL __MODW21
	RET
; 0000 0118 }
; .FEND
;void mGetGameOver() {
; 0000 011B void mGetGameOver() {
_mGetGameOver:
; .FSTART _mGetGameOver
; 0000 011C int j;
; 0000 011D // Check the top two rows (0 and 1) for any non-zero values within the playable area (columns 2 to 9)
; 0000 011E for (j = 2; j < 10; j++) {
	ST   -Y,R17
	ST   -Y,R16
;	j -> R16,R17
	__GETWRN 16,17,2
_0x60:
	__CPWRN 16,17,10
	BRGE _0x61
; 0000 011F if (mMatrix[0][j] != 0 || mMatrix[1][j] != 0) {
	MOVW R30,R16
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x8
	BRNE _0x63
	__POINTW2MN _mMatrix,24
	MOVW R30,R16
	LSL  R30
	ROL  R31
	RCALL SUBOPT_0x8
	BREQ _0x62
_0x63:
; 0000 0120 GameOver = true;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0121 printf("Game Over!\n");
	__POINTW1FN _0x0,18
	RCALL SUBOPT_0xA
; 0000 0122 return;
	RJMP _0x20A0002
; 0000 0123 }
; 0000 0124 }
_0x62:
	__ADDWRN 16,17,1
	RJMP _0x60
_0x61:
; 0000 0125 GameOver = false;
	CLR  R7
; 0000 0126 }
_0x20A0002:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;int read_buttons()
; 0000 012A {
_read_buttons:
; .FSTART _read_buttons
; 0000 012B // Check each button
; 0000 012C if (!(PINC & (1 << 7)))
	SBIC 0x6,7
	RJMP _0x65
; 0000 012D {
; 0000 012E delay_ms(60);  // Debounce delay
	LDI  R26,LOW(60)
	LDI  R27,0
	RCALL _delay_ms
; 0000 012F if (!(PINC & (1 << 7)))  // Check again after delay
	SBIC 0x6,7
	RJMP _0x66
; 0000 0130 {
; 0000 0131 return 1;  // Button on PC7 pressed
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 0132 }
; 0000 0133 }
_0x66:
; 0000 0134 else if (!(PINC & (1 << 6)))
	RJMP _0x67
_0x65:
	SBIC 0x6,6
	RJMP _0x68
; 0000 0135 {
; 0000 0136 delay_ms(60);  // Debounce delay
	LDI  R26,LOW(60)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0137 if (!(PINC & (1 << 6)))  // Check again after delay
	SBIC 0x6,6
	RJMP _0x69
; 0000 0138 {
; 0000 0139 return 2;  // Button on PC6 pressed
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET
; 0000 013A }
; 0000 013B }
_0x69:
; 0000 013C else if (!(PINC & (1 << 5)))
	RJMP _0x6A
_0x68:
	SBIC 0x6,5
	RJMP _0x6B
; 0000 013D {
; 0000 013E delay_ms(60);  // Debounce delay
	LDI  R26,LOW(60)
	LDI  R27,0
	RCALL _delay_ms
; 0000 013F if (!(PINC & (1 << 5)))  // Check again after delay
	SBIC 0x6,5
	RJMP _0x6C
; 0000 0140 {
; 0000 0141 return 3;  // Button on PC5 pressed
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RET
; 0000 0142 }
; 0000 0143 }
_0x6C:
; 0000 0144 else if (!(PINC & (1 << 4)))
	RJMP _0x6D
_0x6B:
	SBIC 0x6,4
	RJMP _0x6E
; 0000 0145 {
; 0000 0146 delay_ms(60);  // Debounce delay
	LDI  R26,LOW(60)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0147 if (!(PINC & (1 << 4)))  // Check again after delay
	SBIC 0x6,4
	RJMP _0x6F
; 0000 0148 {
; 0000 0149 return 4;  // Button on PC5 pressed
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET
; 0000 014A }
; 0000 014B }
_0x6F:
; 0000 014C 
; 0000 014D return 0;  // No button pressed
_0x6E:
_0x6D:
_0x6A:
_0x67:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 014E }
; .FEND
;void mPrintGameOver(){
; 0000 0150 void mPrintGameOver(){
_mPrintGameOver:
; .FSTART _mPrintGameOver
; 0000 0151 int i, j;
; 0000 0152 for(i = 0; i < 8; i++){
	RCALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x71:
	__CPWRN 16,17,8
	BRGE _0x72
; 0000 0153 for(j = 2; j < 10; j++){
	__GETWRN 18,19,2
_0x74:
	__CPWRN 18,19,10
	BRGE _0x75
; 0000 0154 mMatrix[i][j] = 1;
	RCALL SUBOPT_0x7
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   X+,R30
	ST   X,R31
; 0000 0155 }
	__ADDWRN 18,19,1
	RJMP _0x74
_0x75:
; 0000 0156 }
	__ADDWRN 16,17,1
	RJMP _0x71
_0x72:
; 0000 0157 mPrintMatrix();
	RCALL _mPrintMatrix
; 0000 0158 }
_0x20A0001:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;void main(){
; 0000 015A void main(){
_main:
; .FSTART _main
; 0000 015B int randomIndex;
; 0000 015C int input;
; 0000 015D GameOver = false;
;	randomIndex -> R16,R17
;	input -> R18,R19
	CLR  R7
; 0000 015E 
; 0000 015F DDRA = 0xFF; //Set port A pins as output
	LDI  R30,LOW(255)
	OUT  0x1,R30
; 0000 0160 DDRB = 0xFF; //Set port B pins as output
	OUT  0x4,R30
; 0000 0161 
; 0000 0162 PORTA = 0x00; //Set A pins to low
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0163 PORTB = 0xFF; //Set B pins to high
	LDI  R30,LOW(255)
	OUT  0x5,R30
; 0000 0164 
; 0000 0165 DDRC |= (1 << 3); // Set PC3 as output for the buzzer
	SBI  0x7,3
; 0000 0166 
; 0000 0167 // Configure Buttons
; 0000 0168 // Configure PC7, PC6, PC5, PC4 as input
; 0000 0169 DDRC &= ~((1 << 7) | (1 << 6) | (1 << 5) | (1 << 4));
	IN   R30,0x7
	ANDI R30,LOW(0xF)
	OUT  0x7,R30
; 0000 016A 
; 0000 016B // Enable internal pull-up resistors for PC7, PC6, PC5 and PC4
; 0000 016C PORTC |= (1 << 7) | (1 << 6) | (1 << 5) | (1 << 4);
	IN   R30,0x8
	ORI  R30,LOW(0xF0)
	OUT  0x8,R30
; 0000 016D 
; 0000 016E //play_tetris_theme(); // Play the Tetris theme at the start
; 0000 016F 
; 0000 0170 //Main Game Loop
; 0000 0171 while (!GameOver){
_0x76:
	TST  R7
	BRNE _0x78
; 0000 0172 // Game Timing ////////////////////////////////////////////
; 0000 0173 
; 0000 0174 // Initial Game parameters ////////////////////////////////
; 0000 0175 
; 0000 0176 // Check if the game is over before spawning a new piece
; 0000 0177 mGetGameOver();
	RCALL _mGetGameOver
; 0000 0178 if (GameOver) {
	TST  R7
	BRNE _0x78
; 0000 0179 break;
; 0000 017A }
; 0000 017B // Spawn the new piece in the middle of the board
; 0000 017C nPosX = 0;
	CLR  R3
	CLR  R4
; 0000 017D nPosY = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	__PUTW1R 5,6
; 0000 017E 
; 0000 017F // Get a random piece
; 0000 0180 randomIndex = mGetRandomTetrominoIndex();
	RCALL _mGetRandomTetrominoIndex
	MOVW R16,R30
; 0000 0181 mAssignTetromino(randomIndex);
	MOVW R26,R16
	RCALL _mAssignTetromino
; 0000 0182 
; 0000 0183 // Place the piece in the top middle and display the initial move
; 0000 0184 mPlacePiece();
	RCALL _mPlacePiece
; 0000 0185 mPrintMatrix();
	RCALL _mPrintMatrix
; 0000 0186 
; 0000 0187 // Reset nGetNextPiece to false
; 0000 0188 nGetNextPiece = false;
	CLR  R8
; 0000 0189 
; 0000 018A // Initial Game parameters ////////////////////////////////
; 0000 018B // ////////////////////////////////////////////////////////
; 0000 018C // Current Piece Logic ////////////////////////////////////
; 0000 018D 
; 0000 018E // While there is no need for a new piece
; 0000 018F while(!nGetNextPiece){
_0x7A:
	TST  R8
	BRNE _0x7C
; 0000 0190 input = read_buttons();
	RCALL _read_buttons
	MOVW R18,R30
; 0000 0191 mGetUserInput(input);
	MOVW R26,R18
	RCALL _mGetUserInput
; 0000 0192 mPrintMatrix();
	RCALL _mPrintMatrix
; 0000 0193 // Add a small delay to avoid high CPU usage (optional)
; 0000 0194 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0195 }
	RJMP _0x7A
_0x7C:
; 0000 0196 // Current Piece Logic ////////////////////////////////////
; 0000 0197 
; 0000 0198 mClearFullRows();
	RCALL _mClearFullRows
; 0000 0199 }
	RJMP _0x76
_0x78:
; 0000 019A mPrintGameOver();
	RCALL _mPrintGameOver
; 0000 019B while(true){
_0x7D:
; 0000 019C mPrintMatrix();
	RCALL _mPrintMatrix
; 0000 019D }
	RJMP _0x7D
; 0000 019E }
_0x80:
	RJMP _0x80
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R17
	MOV  R17,R26
_0x2000006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	STS  198,R17
	LD   R17,Y+
	RET
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	RCALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	RCALL _putchar
	MOVW R26,R16
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x200001C:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200001E
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000022
	CPI  R18,37
	BRNE _0x2000023
	LDI  R17,LOW(1)
	RJMP _0x2000024
_0x2000023:
	RCALL SUBOPT_0xD
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BRNE _0x2000025
	CPI  R18,37
	BRNE _0x2000026
	RCALL SUBOPT_0xD
	RJMP _0x20000D2
_0x2000026:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000027
	LDI  R16,LOW(1)
	RJMP _0x2000021
_0x2000027:
	CPI  R18,43
	BRNE _0x2000028
	LDI  R20,LOW(43)
	RJMP _0x2000021
_0x2000028:
	CPI  R18,32
	BRNE _0x2000029
	LDI  R20,LOW(32)
	RJMP _0x2000021
_0x2000029:
	RJMP _0x200002A
_0x2000025:
	CPI  R30,LOW(0x2)
	BRNE _0x200002B
_0x200002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x200002C
	ORI  R16,LOW(128)
	RJMP _0x2000021
_0x200002C:
	RJMP _0x200002D
_0x200002B:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x2000021
_0x200002D:
	CPI  R18,48
	BRLO _0x2000030
	CPI  R18,58
	BRLO _0x2000031
_0x2000030:
	RJMP _0x200002F
_0x2000031:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000021
_0x200002F:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000035
	RCALL SUBOPT_0xE
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0xF
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x73)
	BRNE _0x2000038
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x10
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x70)
	BRNE _0x200003B
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x10
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000039:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x200003C
_0x200003B:
	CPI  R30,LOW(0x64)
	BREQ _0x200003F
	CPI  R30,LOW(0x69)
	BRNE _0x2000040
_0x200003F:
	ORI  R16,LOW(4)
	RJMP _0x2000041
_0x2000040:
	CPI  R30,LOW(0x75)
	BRNE _0x2000042
_0x2000041:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x2000043
_0x2000042:
	CPI  R30,LOW(0x58)
	BRNE _0x2000045
	ORI  R16,LOW(8)
	RJMP _0x2000046
_0x2000045:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000077
_0x2000046:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x2000043:
	SBRS R16,2
	RJMP _0x2000048
	RCALL SUBOPT_0xE
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000049
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000049:
	CPI  R20,0
	BREQ _0x200004A
	SUBI R17,-LOW(1)
	RJMP _0x200004B
_0x200004A:
	ANDI R16,LOW(251)
_0x200004B:
	RJMP _0x200004C
_0x2000048:
	RCALL SUBOPT_0xE
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	__GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x200004C:
_0x200003C:
	SBRC R16,0
	RJMP _0x200004D
_0x200004E:
	CP   R17,R21
	BRSH _0x2000050
	SBRS R16,7
	RJMP _0x2000051
	SBRS R16,2
	RJMP _0x2000052
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2000053
_0x2000052:
	LDI  R18,LOW(48)
_0x2000053:
	RJMP _0x2000054
_0x2000051:
	LDI  R18,LOW(32)
_0x2000054:
	RCALL SUBOPT_0xD
	SUBI R21,LOW(1)
	RJMP _0x200004E
_0x2000050:
_0x200004D:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x2000055
_0x2000056:
	CPI  R19,0
	BREQ _0x2000058
	SBRS R16,3
	RJMP _0x2000059
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x200005A
_0x2000059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005A:
	RCALL SUBOPT_0xD
	CPI  R21,0
	BREQ _0x200005B
	SUBI R21,LOW(1)
_0x200005B:
	SUBI R19,LOW(1)
	RJMP _0x2000056
_0x2000058:
	RJMP _0x200005C
_0x2000055:
_0x200005E:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000060:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2000062
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000060
_0x2000062:
	CPI  R18,58
	BRLO _0x2000063
	SBRS R16,3
	RJMP _0x2000064
	SUBI R18,-LOW(7)
	RJMP _0x2000065
_0x2000064:
	SUBI R18,-LOW(39)
_0x2000065:
_0x2000063:
	SBRC R16,4
	RJMP _0x2000067
	CPI  R18,49
	BRSH _0x2000069
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000068
_0x2000069:
	RJMP _0x20000D3
_0x2000068:
	CP   R21,R19
	BRLO _0x200006D
	SBRS R16,0
	RJMP _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x200006F
	LDI  R18,LOW(48)
_0x20000D3:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000070
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0xF
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	RCALL SUBOPT_0xD
	CPI  R21,0
	BREQ _0x2000072
	SUBI R21,LOW(1)
_0x2000072:
_0x200006C:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x200005F
	RJMP _0x200005E
_0x200005F:
_0x200005C:
	SBRS R16,0
	RJMP _0x2000073
_0x2000074:
	CPI  R21,0
	BREQ _0x2000076
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0xF
	RJMP _0x2000074
_0x2000076:
_0x2000073:
_0x2000077:
_0x2000036:
_0x20000D2:
	LDI  R17,LOW(0)
_0x2000021:
	RJMP _0x200001C
_0x200001E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	__ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	__ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG
_rand:
; .FSTART _rand
	LDS  R30,__seed_G101
	LDS  R31,__seed_G101+1
	LDS  R22,__seed_G101+2
	LDS  R23,__seed_G101+3
	__GETD2N 0x41C64E6D
	RCALL __MULD12U
	__ADDD1N 30562
	STS  __seed_G101,R30
	STS  __seed_G101+1,R31
	STS  __seed_G101+2,R22
	STS  __seed_G101+3,R23
	movw r30,r22
	andi r31,0x7F
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.DSEG
_mMatrix:
	.BYTE 0xF0
_mCurrentPiece:
	.BYTE 0x20
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x0:
	MOVW R30,R16
	RCALL __LSLW3
	SUBI R30,LOW(-_mCurrentPiece)
	SBCI R31,HIGH(-_mCurrentPiece)
	MOVW R26,R30
	MOVW R30,R18
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	MOVW R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R18
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x3:
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4:
	MOVW R30,R16
	ADD  R30,R3
	ADC  R31,R4
	LDI  R26,LOW(24)
	LDI  R27,HIGH(24)
	RCALL __MULW12U
	SUBI R30,LOW(-_mMatrix)
	SBCI R31,HIGH(-_mMatrix)
	MOVW R26,R30
	MOVW R30,R18
	ADD  R30,R5
	ADC  R31,R6
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x7:
	__MULBNWRU 16,17,24
	SUBI R30,LOW(-_mMatrix)
	SBCI R31,HIGH(-_mMatrix)
	MOVW R26,R30
	MOVW R30,R18
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	ADD  R26,R30
	ADC  R27,R31
	__GETW1P
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x9:
	__MULBNWRU 20,21,24
	SUBI R30,LOW(-_mMatrix)
	SBCI R31,HIGH(-_mMatrix)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	MOVW R26,R30
	MOVW R30,R18
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_mMatrix)
	LDI  R27,HIGH(_mMatrix)
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xD:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xE:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__MULW12:
__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12:
__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	NEG  R27
	NEG  R26
	SBCI R27,0
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x1388
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
