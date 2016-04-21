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
  INST4 (%0000_0001)
  INST4 (%0000_1100)                                    ' Display on, Cursor off, Blink off                                             
  INST4 (%0000_0110)                                    ' Increment Cursor + No-Display Shift

  e_switch := 1

  INST4 (%0010_1000)                                    ' Now that we're in 4 bits, add N=2 lines, F=5x7 fonts                                              
  INST4 (%0000_0001)
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

PUB B_CTRL(level) | temp

  temp := e_switch

  if(level == 0)
    e_switch := 0
    OUTA[RS] := 1
    INST4 (%0000_0000)  
    

  



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