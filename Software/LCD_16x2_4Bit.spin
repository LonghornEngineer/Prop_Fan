CON
  ' Pin assignment
  RS = 7                   
  RW = 6                    
  E0 = 5
  E1 = 8

  DB4 = 3
  DB5 = 4
  DB6 = 1
  DB7 = 2
   
OBJ

  DELAY : "Timing"

VAR

  BYTE e_switch

PUB START  

  DIRA[DB4] := 1                              ' Set everything to output              
  DIRA[DB5] := 1
  DIRA[DB6] := 1
  DIRA[DB7] := 1
  DIRA[RS] := 1
  DIRA[RW] := 1
  DIRA[E0] := 1
  DIRA[E1] := 1

  INIT 

PRI INIT

  DELAY.pause1ms(15)
  
  OUTA[DB4] := 0                              ' Output low on all pins
  OUTA[DB5] := 0
  OUTA[DB6] := 0
  OUTA[DB7] := 0  
  OUTA[RS] := 0
  OUTA[RW] := 0

  OUTA[E0]  := 1
  OUTA[E1]  := 1
  OUTA[DB4] := 0                             
  OUTA[DB5] := 1
  OUTA[DB6] := 0
  OUTA[DB7] := 0

  OUTA[E0]  := 0
  OUTA[E1]  := 0


  e_switch := 0
  INST4 (%0010_0000)                                    ' Now that we're in 4 bits, add N=2 lines, F=5x7 fonts                                              
  INST4 (%0000_0001)
  INST4 (%0000_1100)                                    ' Display on, Cursor off, Blink off                                             
  INST4 (%0000_0110)                                    ' Increment Cursor + No-Display Shift

  e_switch := 1

  INST4 (%0010_0000)                                    ' Now that we're in 4 bits, add N=2 lines, F=5x7 fonts                                              
  INST4 (%0000_0001)
  INST4 (%0000_1100)                                    ' Display on, Cursor off, Blink off                                             
  INST4 (%0000_0110)                                    ' Increment Cursor + No-Display Shift

  e_switch := 0

  return                                      

PRI INST4 (LCD_DATA)            

  OUTA[RW] := 0                              
  OUTA[RS] := 0                              
  do_E(1)
  'OUTA[DB7..DB4] := LCD_DATA >> 4
  OUTA[DB7] :=  LCD_DATA >> 7
  OUTA[DB6] :=  LCD_DATA >> 6
  OUTA[DB5] :=  LCD_DATA >> 5
  OUTA[DB4] :=  LCD_DATA >> 4 
  do_E(0)                             

  do_E(1)
  'OUTA[DB7..DB4] := LCD_DATA
  OUTA[DB7] :=  LCD_DATA >> 3
  OUTA[DB6] :=  LCD_DATA >> 2
  OUTA[DB5] :=  LCD_DATA >> 1
  OUTA[DB4] :=  LCD_DATA 
  do_E(0)

PRI INST4RS (LCD_DATA)            

  OUTA[RW] := 0                              
  OUTA[RS] := 1                              
  do_E(1)
  'OUTA[DB7..DB4] := LCD_DATA >> 4
  OUTA[DB7] :=  LCD_DATA >> 7
  OUTA[DB6] :=  LCD_DATA >> 6
  OUTA[DB5] :=  LCD_DATA >> 5
  OUTA[DB4] :=  LCD_DATA >> 4  
  do_E(0)                             

  do_E(1)
  'OUTA[DB7..DB4] := LCD_DATA
  OUTA[DB7] :=  LCD_DATA >> 3
  OUTA[DB6] :=  LCD_DATA >> 2
  OUTA[DB5] :=  LCD_DATA >> 1
  OUTA[DB4] :=  LCD_DATA   
  do_E(0)
  
  OUTA[RS] := 0

return                         

PRI CHAR (LCD_DATA)
    

  OUTA[RW] := 0                              
  OUTA[RS] := 1                              

  do_E(1)  
  'OUTA[DB7..DB4] := LCD_DATA >> 4
  OUTA[DB7] :=  LCD_DATA >> 7
  OUTA[DB6] :=  LCD_DATA >> 6
  OUTA[DB5] :=  LCD_DATA >> 5
  OUTA[DB4] :=  LCD_DATA >> 4 
  do_E(0)   

  do_E(1)  
  'OUTA[DB7..DB4] := LCD_DATA
  OUTA[DB7] :=  LCD_DATA >> 3
  OUTA[DB6] :=  LCD_DATA >> 2
  OUTA[DB5] :=  LCD_DATA >> 1
  OUTA[DB4] :=  LCD_DATA 
  do_E(0)  

PRI do_E(e)

  if(e_switch == 0) 
    OUTA[E0]  := e
  else
    OUTA[E1]  := e 

return

PUB B_CTRL(level) | temp

  temp := e_switch

  if(level == 0)
    e_switch := 0
    INST4 (%0010_0000)
    INST4RS (%0000_0011)
    e_switch := 1 
    INST4 (%0010_0000)
    INST4RS (%0000_0011)

  elseif(level == 1)    
    e_switch := 0
    INST4 (%0010_0000)
    INST4RS (%0000_0010)
    e_switch := 1 
    INST4 (%0010_0000)
    INST4RS (%0000_0010)

  elseif(level == 2)    
    e_switch := 0
    INST4 (%0010_0000)    
    INST4RS (%0000_0001)
    e_switch := 1 
    INST4 (%0010_0000)    
    INST4RS (%0000_0001)

  elseif(level == 3)    
    e_switch := 0
    INST4 (%0010_0000)    
    INST4RS (%0000_0000)
    e_switch := 1 
    INST4 (%0010_0000)    
    INST4RS (%0000_0000)

  e_switch := temp
  
return
  
PUB CLEAR
  ' Clear display, Return Cursor Home

  e_switch := 1

  INST4 (%0000_0001)

  e_switch := 0

  INST4 (%0000_0001)

return                                                                 

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