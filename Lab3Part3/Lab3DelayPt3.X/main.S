// Hunter Clezie
// RCET3375
// Lab3DelayPt3
// https://github.com/hunterclezie-pixel/Lab-03---Delays.git

; PIC16F883 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1
  CONFIG  FOSC = XT             ; Oscillator Selection bits (XT oscillator: Crystal/resonator on RA6/OSC2/CLKOUT and RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RE3/MCLR pin function select bit (RE3/MCLR pin function is MCLR)
  CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
  CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
  CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
  CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
  CONFIG  LVP = OFF             ; Low Voltage Programming Enable bit (RB3 pin has digital I/O, HV on MCLR must be used for programming)

; CONFIG2
  CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
  CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

// config statements should precede project file includes.
#include <xc.inc>
  
; Reset Vector at 0000h. Execution starts here after reset.
PSECT resetVect,class=CODE,delta=2
ResetVector:
    goto Setup

; Main code section starts at 0008h. User code goes here.
PSECT code,class=CODE,delta=2
 
Setup:
    ; add device setup here
    BCF 0x03,6 ; Sets Bank 0
    BCF 0x03,5 ; Sets Bank 0
    
    ; PORTB Code:
    ; CCP1CON on power up reset is all LOW
    ; INTCON on power up reset is all LOW
    CLRF 0x06 ; Setting PORTB on reset to LOW
    
    ; PORTC Code:
    ; CCP1CON on power up reset is all LOW
    ; CCP2CON on power up reset is all LOW
    CLRF 0x07 ; Setting PORTC on reset to LOW
    ; RCSTA on power up reset is all LOW
    ; SSPCON on power up reset is all LOW
    ; T1CON on power up reset is all LOW
    
    BCF 0x03,6 ; Sets Bank 1
    BSF 0x03,5 ; Sets Bank 1
    
    ; PORTB Code:
    ; OPTION_REG on power up reset is all HIGH
    MOVLW 0xFF ; Sets all bits high for TRISB
    MOVWF 0x86 ; Setting TRISB on reset to HIGH, making PORTB an input
    CLRF 0x95 ; Sets WPUB bits on reset LOW, disabling pull-up
    ; ICOB on power up reset is all HIGH
    
    ; PORTC Code:
    ; PSTRCON on power up reset is all LOW
    CLRF 0x87 ; Setting TRISC on reset to LOW, making PORTC an output
    
    BSF 0x03,6 ; Sets Bank 2
    BCF 0x03,5 ; Sets Bank 2
    
    ; PORTB Code:
    BSF 0x09,1 ; Setting bit 1 for CM2CON1 HIGH
    
    BSF 0x03,6 ; Sets Bank 3
    BSF 0x03,5 ; Sets Bank 3
    
    ; PORTB Code:
    CLRF 0x89 ; Setting the ANSELH to LOW for the I/O to be digital
    BCF 0x03, 6
    BCF 0x03, 5
    
    BCF 0x03,6		; Sets Bank 0
    BCF 0x03,5		; Sets Bank 0
    outCount EQU 0x20
    midCount EQU 0x21
    inCount EQU 0x22
    MOVLW 0x30
    MOVWF 0x07
    GOTO Main
    
Main:
    MOVLW 0x05          ;1 TCY
    XORWF 0x07,1	;1 TCY

    MOVLW 0X04          ;1 TCY
    MOVWF outCount      ;1 TCY
    NOP
    NOP
    NOP
    goto OutDelay	;2 TCY

OutDelay:
    MOVLW 0XC0          ;1 TCY
    MOVWF midCount      ;1 TCY
    NOP
    NOP
    NOP
    NOP
    NOP
    goto MidDelay       ;2 TCY

MidDelay:
    MOVLW 0xD7          ;1 TCY
    MOVWF inCount       ;1 TCY
    goto InDelay        ;2 TCY

InDelay:
    DECFSZ inCount      ;1 (2) TCY
    goto InDelay        ;2 TCY

    DECFSZ midCount     ;1 (2) TCY
    goto MidDelay       ;2 TCY

    DECFSZ outCount     ;1 (2) TCY
    goto OutDelay	;2 TCY
    goto Main           ;2 TCY
    
End