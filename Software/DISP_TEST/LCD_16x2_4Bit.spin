{{
┌──────────────────────┐
│ Parallel LCD Driver  │
├──────────────────────┴───────────────────────┐
│  Width      : 16 Characters                  │
│  Height     :  2 Lines                       │
│  Interface  :  4 Bit                         │
│  Controller :  HD44780-based                 │
├──────────────────────────────────────────────┤
│  By      : Simon Ampleman                    │
│            sa@infodev.ca                     │
│  Date    : 2006-11-18                        │
│  Version : 1.0                               │
└──────────────────────────────────────────────┘

Hardware used : SSC2F16DLNW-E                    

Schematics
                         P8X32A
                       ┌────┬────┐ 
                       ┤0      31├              0V    5V    0V   P16   P17   P18   N/C   N/C
                       ┤1      30├              │     │     │     │     │     │     │     │
                       ┤2      29├              │VSS  │VDD  │VO   │R/S  │R/W  │E    │DB0  │DB1                              
                       ┤3      28├              ┴1    ┴2    ┴3    ┴4    ┴5    ┴6    ┴7    ┴8
                       ┤4      27├            ┌────────────────────────────────────────────────┐
                       ┤5      26├            │ 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16│  LCD 16X2
                       ┤6      25├            │ 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16│  HD44780-BASED
                       ┤7      24├            └────────────────────────────────────────────────┘  SSC2F16DLNW-E
                       ┤VSS   VDD├              ┬9    ┬10   ┬11   ┬12   ┬13   ┬14   ┬15   ┬16
                       ┤BOEn   XO├              │DB2  │DB3  │DB4  │DB5  │DB6  │DB7  │A(+) │K(-)             
                       ┤RESn   XI├              │     │     │     │     │     │     │     │
                       ┤VDD   VSS├             N/C   N/C   P11   P10   P9    P8     5V    0V
                   DB7 ┤8      23├ 
                   DB6 ┤9      22├ 
                   DB5 ┤10     21├ 
                   DB4 ┤11     20├
                       ┤12     19├ 
                       ┤13     18├ E
                       ┤14     17├ RW
                       ┤15     16├ R/S
                       └─────────┘ 


PIN ASSIGNMENT
   VSS  - POWER SUPPLY (GND)
   VCC  - POWER SUPPLY (+5V)
   VO   - CONTRAST ADJUST (0-5V)
   R/S  - FLAG TO RECEIVE INSTRUCTION OR DATA
            0 - INSTRUCTION
            1 - DATA
   R/W  - INPUT OR OUTPUT MODE
            0 - WRITE TO LCD MODULE
            1 - READ FROM LCD MODULE
   E    - ENABLE SIGNAL 
   DB4  - DATA BUS LINE 4 
   DB5  - DATA BUS LINE 5 
   DB6  - DATA BUS LINE 6 
   DB7  - DATA BUS LINE 7 (MSB)
   A(+) - BACKLIGHT 5V
   K(-) - BACKLIGHT GND

INSTRUCTION SET
   ┌──────────────────────┬───┬───┬─────┬───┬───┬───┬───┬───┬───┬───┬───┬─────┬─────────────────────────────────────────────────────────────────────┐
   │  INSTRUCTION         │R/S│R/W│     │DB7│DB6│DB5│DB4│DB3│DB2│DB1│DB0│     │ Description                                                         │
   ├──────────────────────┼───┼───┼─────┼───┼───┼───┼───┼───┼───┼───┼───┼─────┼─────────────────────────────────────────────────────────────────────┤
   │ CLEAR DISPLAY        │ 0 │ 0 │     │ 0 │ 0 │ 0 │ 0 │ 0 │ 0 │ 0 │ 1 │     │ Clears display and returns cursor to the home position (address 0). │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ CURSOR HOME          │ 0 │ 0 │     │ 0 │ 0 │ 0 │ 0 │ 0 │ 0 │ 1 │ * │     │ Returns cursor to home position (address 0). Also returns display   │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │ being shifted to the original position.                             │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ ENTRY MODE SET       │ 0 │ 0 │     │ 0 │ 0 │ 0 │ 0 │ 0 │ 1 │I/D│ S │     │ Sets cursor move direction (I/D), specifies to shift the display(S) │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │ These operations are performed during data read/write.              │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ DISPLAY ON/OFF       │ 0 │ 0 │     │ 0 │ 0 │ 0 │ 0 │ 1 │ D │ C │ B │     │ Sets On/Off of all display (D), cursor On/Off (C) and blink of      │
   │ CONTROL              │   │   │     │   │   │   │   │   │   │   │   │     │ cursor position character (B).                                      │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ CURSOR/DISPLAY       │ 0 │ 0 │     │ 0 │ 0 │ 0 │ 1 │S/C│R/L│ * │ * │     │ Sets cursor-move or display-shift (S/C), shift direction (R/L).     │
   │ SHIFT                │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ FUNCTION SET         │ 0 │ 0 │     │ 0 │ 0 │ 1 │ DL│ N │ F │ * │ * │     │ Sets interface data length (DL), number of display line (N) and     │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │ character font(F).                                                  │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ SET CGRAM ADDRESS    │ 0 │ 0 │     │ 0 │ 1 │      CGRAM ADDRESS    │     │ Sets the CGRAM address. CGRAM data is sent and received after       │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │ this setting.                                                       │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ SET DDRAM ADDRESS    │ 0 │ 0 │     │ 1 │       DDRAM ADDRESS       │     │ Sets the DDRAM address. DDRAM data is sent and received after       │                                                             
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │ this setting.                                                       │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ READ BUSY FLAG AND   │ 0 │ 1 │     │ BF│    CGRAM/DDRAM ADDRESS    │     │ Reads Busy-flag (BF) indicating internal operation is being         │
   │ ADDRESS COUNTER      │   │   │     │   │   │   │   │   │   │   │   │     │ performed and reads CGRAM or DDRAM address counter contents.        │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ WRITE TO CGRAM OR    │ 1 │ 0 │     │         WRITE DATA            │     │ Writes data to CGRAM or DDRAM.                                      │
   │ DDRAM                │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │ READ FROM CGRAM OR   │ 1 │ 1 │     │          READ DATA            │     │ Reads data from CGRAM or DDRAM.                                     │
   │ DDRAM                │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   │                      │   │   │     │   │   │   │   │   │   │   │   │     │                                                                     │
   └──────────────────────┴───┴───┴─────┴───┴───┴───┴───┴───┴───┴───┴───┴─────┴─────────────────────────────────────────────────────────────────────┘
   Remarks :
            * = 0 OR 1
        DDRAM = Display Data Ram
                Corresponds to cursor position                  
        CGRAM = Character Generator Ram        

   ┌──────────┬──────────────────────────────────────────────────────────────────────┐
   │ BIT NAME │                          SETTING STATUS                              │                                                              
   ├──────────┼─────────────────────────────────┬────────────────────────────────────┤
   │  I/D     │ 0 = Decrement cursor position   │ 1 = Increment cursor position      │
   │  S       │ 0 = No display shift            │ 1 = Display shift                  │
   │  D       │ 0 = Display off                 │ 1 = Display on                     │
   │  C       │ 0 = Cursor off                  │ 1 = Cursor on                      │
   │  B       │ 0 = Cursor blink off            │ 1 = Cursor blink on                │
   │  S/C     │ 0 = Move cursor                 │ 1 = Shift display                  │
   │  R/L     │ 0 = Shift left                  │ 1 = Shift right                    │
   │  DL      │ 0 = 4-bit interface             │ 1 = 8-bit interface                │
   │  N       │ 0 = 1/8 or 1/11 Duty (1 line)   │ 1 = 1/16 Duty (2 lines)            │
   │  F       │ 0 = 5x7 dots                    │ 1 = 5x10 dots                      │
   │  BF      │ 0 = Can accept instruction      │ 1 = Internal operation in progress │
   └──────────┴─────────────────────────────────┴────────────────────────────────────┘

   DDRAM ADDRESS USAGE FOR A 1-LINE DISPLAY
   
    00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39   <- CHARACTER POSITION
   ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
   │00│01│02│03│04│05│06│07│08│09│0A│0B│0C│0D│0E│0F│10│11│12│13│14│15│16│17│18│19│1A│1B│1C│1D│1E│1F│20│21│22│23│24│25│26│27│  <- ROW0 DDRAM ADDRESS
   └──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘

   DDRAM ADDRESS USAGE FOR A 2-LINE DISPLAY

    00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39   <- CHARACTER POSITION
   ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
   │00│01│02│03│04│05│06│07│08│09│0A│0B│0C│0D│0E│0F│10│11│12│13│14│15│16│17│18│19│1A│1B│1C│1D│1E│1F│20│21│22│23│24│25│26│27│  <- ROW0 DDRAM ADDRESS
   │40│41│42│43│44│45│46│47│48│49│4A│4B│4C│4D│4E│4F│50│51│52│53│54│55│56│57│58│59│5A│5B│5C│5D│5E│5F│60│61│62│63│64│65│66│67│  <- ROW1 DDRAM ADDRESS
   └──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘

   DDRAM ADDRESS USAGE FOR A 4-LINE DISPLAY

    00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19   <- CHARACTER POSITION
   ┌──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┬──┐
   │00│01│02│03│04│05│06│07│08│09│0A│0B│0C│0D│0E│0F│10│11│12│13│  <- ROW0 DDRAM ADDRESS
   │40│41│42│43│44│45│46│47│48│49│4A│4B│4C│4D│4E│4F│50│51│52│53│  <- ROW1 DDRAM ADDRESS
   │14│15│16│17│18│19│1A│1B│1C│1D│1E│1F│20│21│22│23│24│25│26│27│  <- ROW2 DDRAM ADDRESS
   │54│55│56│57│58│59│5A│5B│5C│5D│5E│5F│60│61│62│63│64│65│66│67│  <- ROW3 DDRAM ADDRESS
   └──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┴──┘
  
}}      
        
        
        
CON

  ' Pin assignment
  RS = 21                   
  RW = 23                    
  E0 = 22
  E1 = 20

  DB4 = 24
  DB7 = 27
   
OBJ

  DELAY : "Timing"

VAR

  BYTE e_switch

PUB START  

  DIRA[DB7..DB4] := %1111                               ' Set everything to output              
  DIRA[RS] := 1
  DIRA[RW] := 1
  DIRA[E0] := 1
  DIRA[E1] := 1

  INIT 

PRI INIT

  DELAY.pause1ms(15)
  
  OUTA[DB7..DB4] := %0000                               ' Output low on all pins
  OUTA[RS] := 0
  OUTA[RW] := 0

  OUTA[E0]  := 1
  OUTA[E1]  := 1
  OUTA[DB7..DB4] := %0010                               ' Set to DL=4 bits
  OUTA[E0]  := 0
  OUTA[E1]  := 0


  e_switch := 0
  INST4 (%0010_1000)                                    ' Now that we're in 4 bits, add N=2 lines, F=5x7 fonts                                              
  CLEAR
  INST4 (%0000_1100)                                    ' Display on, Cursor off, Blink off                                             
  INST4 (%0000_0110)                                    ' Increment Cursor + No-Display Shift

  e_switch := 1

  INST4 (%0010_1000)                                    ' Now that we're in 4 bits, add N=2 lines, F=5x7 fonts                                              
  CLEAR
  INST4 (%0000_1100)                                    ' Display on, Cursor off, Blink off                                             
  INST4 (%0000_0110)                                    ' Increment Cursor + No-Display Shift

  e_switch := 0

  return                                      

PRI BUSY | IS_BUSY
  DELAY.pause1ms(5)                                     ' I did not find a way to read busy flag in 4 bit correctly

PRI INST4 (LCD_DATA)            

  BUSY

  OUTA[RW] := 0                              
  OUTA[RS] := 0                              
  do_E(1)
  OUTA[DB7..DB4] := LCD_DATA >> 4
  do_E(0)                             

  BUSY

  do_E(1)
  OUTA[DB7..DB4] := LCD_DATA
  do_E(0)                           

PRI CHAR (LCD_DATA)
    
  BUSY

  OUTA[RW] := 0                              
  OUTA[RS] := 1                              

  do_E(1)  
  OUTA[DB7..DB4] := LCD_DATA >> 4  
  do_E(0)   

  BUSY

  do_E(1)  
  OUTA[DB7..DB4] := LCD_DATA
  do_E(0)  

PRI do_E(e)

  if(e_switch == 0) 
    OUTA[E0]  := e
  else
    OUTA[E1]  := e 

return
  
PUB CLEAR
  ' Clear display, Return Cursor Home
  INST4 (%0000_0001)                                                                               

PUB MOVE (X,Y) | ADR
  ' X : Horizontal Position : 1 to 16
  ' Y : Line Number         : 1 or 2

  if(Y =< 2 )
    e_switch := 0
    ADR := (Y-1) * 64
    ADR += (X-1) + 128
  else
    e_switch := 1
    ADR := (Y-3) * 64
    ADR += (X-1) + 128

  
  INST4 (ADR)

PUB STR (STRINGPTR)
  REPEAT STRSIZE(STRINGPTR)
    CHAR(BYTE[STRINGPTR++])
                              
PUB DEC (VALUE) | TEMP
  IF (VALUE < 0)
    -VALUE
    CHAR("-")

  TEMP := 1_000_000_000

  REPEAT 10
    IF (VALUE => TEMP)
      CHAR(VALUE / TEMP + "0")
      VALUE //= TEMP
      RESULT~~
    ELSEIF (RESULT OR TEMP == 1)
      CHAR("0")
    TEMP /= 10

PUB HEX (VALUE, DIGITS)

  VALUE <<= (8 - DIGITS) << 2
  REPEAT DIGITS
    CHAR(LOOKUPZ((VALUE <-= 4) & $F : "0".."9", "A".."F"))

PUB BIN (VALUE, DIGITS)

  VALUE <<= 32 - DIGITS
  REPEAT DIGITS
    CHAR((VALUE <-= 1) & 1 + "0")