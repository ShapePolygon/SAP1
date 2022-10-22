A Verilog implementation of SAP1 that can execute and display SAP1 programs from an external 8x8 RAM.
Switches are used to program the external RAM and to display internal registers.

Device Operation:
SW[9] and SW[8] are used to set the mode, specifically:
   mode = {SW[9], SW[8]}
   if mode = 0 : read data from RAM by specifying the address via SW[7:0],
        the seven-segments will display Axxdyy where xx is the address 
        and yy is the data read from RAM
   if mode = 1 : write data to RAM with the specified address previously assigned during mode = 0. 
        Data is still specified via SW[7:0], the seven-segments will display Axxdyy 
        where xx is the address and yy is the data read from RAM. 
        Data will be written to RAM if KEY[0] is pressed. 
        The display should reflect the written value to yy.
	
   NOTE: LEDR[9:7] displays the value of CE, WE, and OE in their inverted 
        active state. Thus if CE and WE are both zeroes (write mode),
        LEDR[9] and LEDR[8] should be lit. If CE and OE are active (read mdoe),
        LEDR[9] and LEDR[7] should be lit with LEDR[8] turned off.

   if mode = 2 : SAP 1 mode. Reads the program in RAM. At every program start,
        a clear signal should be supplied via KEY[3]. Pressing KEY[3] should 
        reset all registers to zero and T state to 1.
        T states are displayed via LEDs emulating a progress bar
        (i.e. if T state = 1, LEDR[5:0] = 000001,
              if T state = 2, LEDR[5:0] = 000011,
              if T state = 3, LEDR[5:0] = 000111, and so on).
	Registers values can be displayed individually using SW[7:0], specifically,
              display the registers if SW[9:0] is:
              0 (PC) : PC-xx   1 (MAR): Ar-xx   2 (MDR): dr-xx
 	      3 (IR) : ir-xx   4 (A)  : A-xx    5 (TMP): t-xx
 	      6 (OUT): o-xx
   if mode = 3 : Clock select mode. Select a clock to drive SAP 1. By default, manual
        clock is supplied via KEY[0]. The supplied clock is active with mode = 2 and 3.
        Clear is also active during this mode via KEY[3].
        SW[0] is used to select between auto and manual mode. 
        In this mode, the seven-segments will display A0--S0. 
        A0 indicates manual mode if SW[0] = 0, while
        A1 indicates auto mode if SW[0] = 1.
        Clock in auto mode can be adjusted in 100ms increments in four steps, specifically,
        S0 indicates a speed of 100ms,
        S1 indicates a speed of 200ms,
        S2 indicates a speed of 300ms,
        S3 indicates a speed of 400ms.
        Clock speed can be adjusted using KEY[1] and KEY[2]. 
        KEY[1] increases the speed, KEY[2] decreases the speed.

Sample workflow, assume the given program:

mnemonic     | opcode
-----------------------
00h LDA Ah   | 0Ah
01h ADD Bh   | 1Bh
02h SUB Ch   | 2Ch
03h OUT      | E0h
04h HLT      | F0h
05h          | --
06h          | --
07h          | --
08h          | --
09h          | --
0Ah          | 3Eh
0Bh          | 05h
0Ch          | --
0Dh          | --
0Eh          | --
0Fh          | --

0. Setting the mode
  for mode 0: Set SW[9] = 0 and SW[8] = 0
  for mode 1: Set SW[9] = 0 and SW[8] = 0
  for mode 2: Set SW[9] = 1 and SW[8] = 0
  for mode 3: Set SW[9] = 1 and SW[8] = 1

1. Program the memory
  Set mode to 0, set A = 00h via SW[7:0]
  Set mode to 1, set d = 0Ah via SW[7:0]

  Set mode to 0, set A = 01h via SW[7:0]
  Set mode to 1, set d = 1Bh via SW[7:0]
  
  Set mode to 0, set A = 02h via SW[7:0]
  Set mode to 1, set d = 2Ch via SW[7:0]

  Set mode to 0, set A = 03h via SW[7:0]
  Set mode to 1, set d = E0h via SW[7:0]

  Set mode to 0, set A = 04h via SW[7:0]
  Set mode to 1, set d = F0h via SW[7:0]

2. Run the program
  Set mode to 2
  Press Key[3] to initialize all registers
  Press Key[0] to provide a clock pulse
  Change the register display of seven segments via SW
      Set SW[7:0] = 0 to display PC
      Set SW[7:0] = 1 to display Mar
      Set SW[7:0] = 2 to display MDR
      Set SW[7:0] = 3 to display IR
      Set SW[7:0] = 4 to display A
      Set SW[7:0] = 5 to display TMP
      Set SW[7:0] = 6 to display OUT

3. (Optional) Set the clock mode
  Set mode to 3
  Set SW[0] to 1 to change to auto mode
  Press KEY[2] or KEY[1] to decrease or increase the clock speed
  Switch back to mode 2
  Press Key[3] to clear
  Watch the values change with the automatic clock

------------------------- Technical Specifications -------------------------

Device: 5CSXFC6D6F31C6 (DE10-Standard)*

Pinouts:
clk: 50 MHz
SW_input: SW[9:0]
KEY_input: KEY[3:0]
HEX0: HEX0[6:0]
HEX1: HEX1[6:0]
HEX2: HEX2[6:0]
HEX3: HEX3[6:0]
HEX4: HEX4[6:0]
HEX5: HEX5[6:0]
LEDR: LEDR[9:0]

CE: GPIO_0_D0
WE: GPIO_0_D2
OE: GPIO_0_D4
A:  GPIO_0_D10 - GPIO_0_D24
DQ: GPIO_0_D11 - GPIO_0_D25

Pin assignments can be exported in Quartus via:Assignments>Import Assignments
Pinout assignment file location: \atom_netlists\Pinouts.qsf

*You can change the device but make sure to update the pin assignments for your device.
Do not import the pinouts file for a different device since different devices have
different pinouts address locations.