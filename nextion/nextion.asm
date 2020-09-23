
_manda_serial_const:

;nextion.c,16 :: 		void manda_serial_const(const char *info){
;nextion.c,17 :: 		while(*info){
L_manda_serial_const0:
	MOVF       FARG_manda_serial_const_info+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       FARG_manda_serial_const_info+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      R0+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_manda_serial_const1
;nextion.c,18 :: 		UART1_Write(*info++);
	MOVF       FARG_manda_serial_const_info+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       FARG_manda_serial_const_info+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      FARG_UART1_Write_data_+0
	CALL       _UART1_Write+0
	INCF       FARG_manda_serial_const_info+0, 1
	BTFSC      STATUS+0, 2
	INCF       FARG_manda_serial_const_info+1, 1
;nextion.c,19 :: 		}
	GOTO       L_manda_serial_const0
L_manda_serial_const1:
;nextion.c,20 :: 		}
L_end_manda_serial_const:
	RETURN
; end of _manda_serial_const

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;nextion.c,24 :: 		void interrupt(){
;nextion.c,25 :: 		if (RCIF_bit == 1){//analiza si hay dato serial
	BTFSS      RCIF_bit+0, BitPos(RCIF_bit+0)
	GOTO       L_interrupt2
;nextion.c,26 :: 		dato=RCREG;  //lee el dato
	MOVF       RCREG+0, 0
	MOVWF      _dato+0
;nextion.c,27 :: 		trama[cuenta] = dato;   //lo almacena en el vector
	MOVF       _cuenta+0, 0
	ADDLW      _trama+0
	MOVWF      FSR
	MOVF       _dato+0, 0
	MOVWF      INDF+0
;nextion.c,28 :: 		if ((cuenta > 3) && (trama[cuenta] == 0xff) && (trama[cuenta-1] == 0xff) && (trama[cuenta-2] == 0xff)){
	MOVF       _cuenta+0, 0
	SUBLW      3
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt5
	MOVF       _cuenta+0, 0
	ADDLW      _trama+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt5
	MOVLW      1
	SUBWF      _cuenta+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      _trama+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt5
	MOVLW      2
	SUBWF      _cuenta+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSS      STATUS+0, 0
	DECF       R0+1, 1
	MOVF       R0+0, 0
	ADDLW      _trama+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt5
L__interrupt16:
;nextion.c,29 :: 		flag_rx = 1;//activa la bandera de que llego trama comple y ista para procesar
	MOVLW      1
	MOVWF      _flag_rx+0
;nextion.c,30 :: 		CREN_bit = 0;  //DESHABILITA LA RECEPCION CONTINU PARA LIMPIAR BUFFER    Y NO RECIBIR MIENTRA VA A NALIZAR
	BCF        CREN_bit+0, BitPos(CREN_bit+0)
;nextion.c,31 :: 		INTCON.F7 = 0;  //deshabilita las interrpciones para poder procesar la trama
	BCF        INTCON+0, 7
;nextion.c,32 :: 		}
L_interrupt5:
;nextion.c,33 :: 		cuenta++;//incrementa contador o puntero del vectro de recibido
	INCF       _cuenta+0, 1
;nextion.c,35 :: 		if (cuenta == 30){
	MOVF       _cuenta+0, 0
	XORLW      30
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt6
;nextion.c,36 :: 		flag_rx = 0;
	CLRF       _flag_rx+0
;nextion.c,37 :: 		cuenta = 0;
	CLRF       _cuenta+0
;nextion.c,38 :: 		}
L_interrupt6:
;nextion.c,39 :: 		PIR1.F5 = 0; //limpia el bit de interrupcion
	BCF        PIR1+0, 5
;nextion.c,40 :: 		}
L_interrupt2:
;nextion.c,41 :: 		}
L_end_interrupt:
L__interrupt19:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_procesa_Rx:

;nextion.c,44 :: 		void procesa_Rx(){
;nextion.c,45 :: 		if (flag_rx==1){//si la bandera de la trama esta activa
	MOVF       _flag_rx+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_procesa_Rx7
;nextion.c,47 :: 		if ( strstr(trama,"DAC=")){
	MOVLW      _trama+0
	MOVWF      FARG_strstr_s1+0
	MOVLW      ?lstr1_nextion+0
	MOVWF      FARG_strstr_s2+0
	CALL       _strstr+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_procesa_Rx8
;nextion.c,49 :: 		}
L_procesa_Rx8:
;nextion.c,50 :: 		memset(trama,0,30);
	MOVLW      _trama+0
	MOVWF      FARG_memset_p1+0
	CLRF       FARG_memset_character+0
	MOVLW      30
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;nextion.c,51 :: 		cuenta=0;  //limpia el contador
	CLRF       _cuenta+0
;nextion.c,52 :: 		flag_rx=0; //limpia la bandera
	CLRF       _flag_rx+0
;nextion.c,53 :: 		PIR1.F5=0; //limpia la bandera de interrpcion
	BCF        PIR1+0, 5
;nextion.c,54 :: 		CREN_bit=1;
	BSF        CREN_bit+0, BitPos(CREN_bit+0)
;nextion.c,55 :: 		INTCON.F7=1;
	BSF        INTCON+0, 7
;nextion.c,56 :: 		}
L_procesa_Rx7:
;nextion.c,57 :: 		}
L_end_procesa_Rx:
	RETURN
; end of _procesa_Rx

_mover_Graph:

;nextion.c,58 :: 		void mover_Graph(){
;nextion.c,59 :: 		for(i = 0; i<255; i++){
	CLRF       _i+0
	CLRF       _i+1
L_mover_Graph9:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__mover_Graph22
	MOVLW      255
	SUBWF      _i+0, 0
L__mover_Graph22:
	BTFSC      STATUS+0, 0
	GOTO       L_mover_Graph10
;nextion.c,60 :: 		sprinti(envia,"add 1,0,%d",i);
	MOVLW      _envia+0
	MOVWF      FARG_sprinti_wh+0
	MOVLW      ?lstr_2_nextion+0
	MOVWF      FARG_sprinti_f+0
	MOVLW      hi_addr(?lstr_2_nextion+0)
	MOVWF      FARG_sprinti_f+1
	MOVF       _i+0, 0
	MOVWF      FARG_sprinti_wh+3
	MOVF       _i+1, 0
	MOVWF      FARG_sprinti_wh+4
	CALL       _sprinti+0
;nextion.c,61 :: 		UART1_Write_Text(envia);
	MOVLW      _envia+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;nextion.c,62 :: 		manda_serial_const("\xFF\xFF\xFF");
	MOVLW      ?lstr_3_nextion+0
	MOVWF      FARG_manda_serial_const_info+0
	MOVLW      hi_addr(?lstr_3_nextion+0)
	MOVWF      FARG_manda_serial_const_info+1
	CALL       _manda_serial_const+0
;nextion.c,59 :: 		for(i = 0; i<255; i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;nextion.c,63 :: 		}
	GOTO       L_mover_Graph9
L_mover_Graph10:
;nextion.c,64 :: 		}
L_end_mover_Graph:
	RETURN
; end of _mover_Graph

_main:

;nextion.c,66 :: 		void main() {
;nextion.c,67 :: 		ANSEL=0;                           //Pines analogicos del puerto A, B desactivados
	CLRF       ANSEL+0
;nextion.c,68 :: 		ANSELH=0;                          //Pines analogicos del puerto E desactivados
	CLRF       ANSELH+0
;nextion.c,70 :: 		PORTA=0;
	CLRF       PORTA+0
;nextion.c,71 :: 		PORTD=0;
	CLRF       PORTD+0
;nextion.c,72 :: 		PORTC=0;
	CLRF       PORTC+0
;nextion.c,73 :: 		PORTB=0;
	CLRF       PORTB+0
;nextion.c,74 :: 		PORTE=0;
	CLRF       PORTE+0
;nextion.c,75 :: 		TRISA=0;
	CLRF       TRISA+0
;nextion.c,76 :: 		TRISB=0;
	CLRF       TRISB+0
;nextion.c,77 :: 		TRISD=0;
	CLRF       TRISD+0
;nextion.c,78 :: 		TRISE=0;
	CLRF       TRISE+0
;nextion.c,79 :: 		TRISC6_bit=0; //salida pin TX
	BCF        TRISC6_bit+0, BitPos(TRISC6_bit+0)
;nextion.c,80 :: 		TRISC7_bit=1; //entrada pin RX
	BSF        TRISC7_bit+0, BitPos(TRISC7_bit+0)
;nextion.c,81 :: 		cuenta=0;
	CLRF       _cuenta+0
;nextion.c,82 :: 		UART1_Init(9600);
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;nextion.c,83 :: 		memset(envia,0,30);
	MOVLW      _envia+0
	MOVWF      FARG_memset_p1+0
	CLRF       FARG_memset_character+0
	MOVLW      30
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;nextion.c,85 :: 		PIR1.F5=0;
	BCF        PIR1+0, 5
;nextion.c,86 :: 		PIE1.F5=1;
	BSF        PIE1+0, 5
;nextion.c,87 :: 		INTCON.F6=1;
	BSF        INTCON+0, 6
;nextion.c,88 :: 		INTCON.F7=1;
	BSF        INTCON+0, 7
;nextion.c,89 :: 		while(1){
L_main12:
;nextion.c,91 :: 		mover_Graph();
	CALL       _mover_Graph+0
;nextion.c,92 :: 		if(flag_rx){
	MOVF       _flag_rx+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main14
;nextion.c,93 :: 		procesa_Rx();
	CALL       _procesa_Rx+0
;nextion.c,94 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main15:
	DECFSZ     R13+0, 1
	GOTO       L_main15
	DECFSZ     R12+0, 1
	GOTO       L_main15
	DECFSZ     R11+0, 1
	GOTO       L_main15
	NOP
	NOP
;nextion.c,95 :: 		}
L_main14:
;nextion.c,96 :: 		}
	GOTO       L_main12
;nextion.c,97 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
