
_resetAll:

;nextion.c,53 :: 		void resetAll(){       //Se resetean todas las variables
;nextion.c,54 :: 		cuenta = 0;//contador de datos que llegan
	CLRF       _cuenta+0
;nextion.c,55 :: 		flag_rx = 0;//bandera de que la nextion mando info
	CLRF       _flag_rx+0
;nextion.c,56 :: 		dato = 0;
	CLRF       _dato+0
;nextion.c,57 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;nextion.c,58 :: 		flag_mv = 0;
	CLRF       _flag_mv+0
	CLRF       _flag_mv+1
;nextion.c,59 :: 		flag_end = 0;
	CLRF       _flag_end+0
	CLRF       _flag_end+1
;nextion.c,60 :: 		der = 0;
	CLRF       _der+0
	CLRF       _der+1
;nextion.c,61 :: 		a = 0;
	CLRF       _a+0
	CLRF       _a+1
;nextion.c,63 :: 		banderaUp = 0;
	CLRF       _banderaUp+0
;nextion.c,64 :: 		banderaOk = 0;
	CLRF       _banderaOk+0
;nextion.c,65 :: 		banderaDown = 0;
	CLRF       _banderaDown+0
;nextion.c,66 :: 		opcion = 0;
	CLRF       _opcion+0
	CLRF       _opcion+1
;nextion.c,67 :: 		lect = 0;
	CLRF       _lect+0
	CLRF       _lect+1
;nextion.c,68 :: 		CargaTiempo = 0;
	CLRF       _CargaTiempo+0
	CLRF       _CargaTiempo+1
;nextion.c,69 :: 		cnt =0;
	CLRF       _cnt+0
	CLRF       _cnt+1
	CLRF       _cnt+2
	CLRF       _cnt+3
;nextion.c,70 :: 		tiempo = 0;
	CLRF       _tiempo+0
	CLRF       _tiempo+1
	CLRF       _tiempo+2
	CLRF       _tiempo+3
;nextion.c,71 :: 		cntUser = 0;
	CLRF       _cntUser+0
	CLRF       _cntUser+1
	CLRF       _cntUser+2
	CLRF       _cntUser+3
;nextion.c,72 :: 		segundos = 0;
	CLRF       _segundos+0
	CLRF       _segundos+1
;nextion.c,73 :: 		minutos = 0;
	CLRF       _minutos+0
	CLRF       _minutos+1
;nextion.c,74 :: 		horas = 0;
	CLRF       _horas+0
	CLRF       _horas+1
;nextion.c,75 :: 		timing = 0;
	CLRF       _timing+0
;nextion.c,76 :: 		decena = 0;
	CLRF       _decena+0
;nextion.c,77 :: 		espacio = 0;
	CLRF       _espacio+0
;nextion.c,78 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;nextion.c,79 :: 		tope = 0;
	CLRF       _tope+0
	CLRF       _tope+1
;nextion.c,80 :: 		j = 0;
	CLRF       _j+0
	CLRF       _j+1
;nextion.c,81 :: 		desp = 0;
	CLRF       _desp+0
	CLRF       _desp+1
;nextion.c,82 :: 		memset(envia,0,30);
	MOVLW      _envia+0
	MOVWF      FARG_memset_p1+0
	CLRF       FARG_memset_character+0
	MOVLW      30
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;nextion.c,83 :: 		memset(trama,0,30);
	MOVLW      _trama+0
	MOVWF      FARG_memset_p1+0
	CLRF       FARG_memset_character+0
	MOVLW      30
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;nextion.c,84 :: 		memset(txtLong,0,10);
	MOVLW      _txtLong+0
	MOVWF      FARG_memset_p1+0
	CLRF       FARG_memset_character+0
	MOVLW      10
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;nextion.c,85 :: 		memset(valor,0,2);
	MOVLW      _valor+0
	MOVWF      FARG_memset_p1+0
	CLRF       FARG_memset_character+0
	MOVLW      2
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;nextion.c,86 :: 		memset(text,0,3);
	MOVLW      _text+0
	MOVWF      FARG_memset_p1+0
	CLRF       FARG_memset_character+0
	MOVLW      3
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;nextion.c,87 :: 		}
L_end_resetAll:
	RETURN
; end of _resetAll

_initTMR0:

;nextion.c,89 :: 		void initTMR0(){//Arranca el TMR0
;nextion.c,90 :: 		OPTION_REG = 0x82;
	MOVLW      130
	MOVWF      OPTION_REG+0
;nextion.c,91 :: 		TMR0  = 6;
	MOVLW      6
	MOVWF      TMR0+0
;nextion.c,92 :: 		INTCON = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;nextion.c,93 :: 		}
L_end_initTMR0:
	RETURN
; end of _initTMR0

_manda_serial_const:

;nextion.c,95 :: 		void manda_serial_const(const char *info){
;nextion.c,96 :: 		while(*info){
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
;nextion.c,97 :: 		UART1_Write(*info++);
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
;nextion.c,98 :: 		}
	GOTO       L_manda_serial_const0
L_manda_serial_const1:
;nextion.c,99 :: 		}
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

;nextion.c,103 :: 		void interrupt(){
;nextion.c,104 :: 		if (RCIF_bit == 1){//analiza si hay dato serial
	BTFSS      RCIF_bit+0, BitPos(RCIF_bit+0)
	GOTO       L_interrupt2
;nextion.c,105 :: 		dato=RCREG;  //lee el dato
	MOVF       RCREG+0, 0
	MOVWF      _dato+0
;nextion.c,106 :: 		trama[cuenta] = dato;   //lo almacena en el vector
	MOVF       _cuenta+0, 0
	ADDLW      _trama+0
	MOVWF      FSR
	MOVF       _dato+0, 0
	MOVWF      INDF+0
;nextion.c,107 :: 		if ((cuenta > 3) && ((unsigned char)trama[cuenta] == 0xff) && ((unsigned char)trama[cuenta-1] == 0xff) && ((unsigned char)trama[cuenta-2] == 0xff)){
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
L__interrupt29:
;nextion.c,108 :: 		flag_rx = 1;//activa la bandera de que llego trama comple y ista para procesar
	MOVLW      1
	MOVWF      _flag_rx+0
;nextion.c,109 :: 		CREN_bit = 0;  //DESHABILITA LA RECEPCION CONTINUA PARA LIMPIAR BUFFER    Y NO RECIBIR MIENTRA VA A NALIZAR
	BCF        CREN_bit+0, BitPos(CREN_bit+0)
;nextion.c,110 :: 		INTCON.F7 = 0;  //deshabilita las interrpciones para poder procesar la trama
	BCF        INTCON+0, 7
;nextion.c,111 :: 		}
L_interrupt5:
;nextion.c,112 :: 		cuenta++;//incrementa contador o puntero del vectro de recibido
	INCF       _cuenta+0, 1
;nextion.c,114 :: 		if (cuenta >= 30){
	MOVLW      30
	SUBWF      _cuenta+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_interrupt6
;nextion.c,115 :: 		flag_rx = 0;
	CLRF       _flag_rx+0
;nextion.c,116 :: 		cuenta = 0;
	CLRF       _cuenta+0
;nextion.c,117 :: 		flag_mv = 0;
	CLRF       _flag_mv+0
	CLRF       _flag_mv+1
;nextion.c,118 :: 		}
L_interrupt6:
;nextion.c,119 :: 		PIR1.F5 = 0; //limpia el bit de interrupcion
	BCF        PIR1+0, 5
;nextion.c,120 :: 		}
L_interrupt2:
;nextion.c,121 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_interrupt7
;nextion.c,122 :: 		flag_mv = 1;
	MOVLW      1
	MOVWF      _flag_mv+0
	MOVLW      0
	MOVWF      _flag_mv+1
;nextion.c,123 :: 		cnt++;
	MOVF       _cnt+0, 0
	MOVWF      R0+0
	MOVF       _cnt+1, 0
	MOVWF      R0+1
	MOVF       _cnt+2, 0
	MOVWF      R0+2
	MOVF       _cnt+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _cnt+0
	MOVF       R0+1, 0
	MOVWF      _cnt+1
	MOVF       R0+2, 0
	MOVWF      _cnt+2
	MOVF       R0+3, 0
	MOVWF      _cnt+3
;nextion.c,124 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;nextion.c,125 :: 		TMR0 = 6;
	MOVLW      6
	MOVWF      TMR0+0
;nextion.c,126 :: 		if(cnt == 1000){//Aproximación a 1.03 segundos
	MOVLW      0
	MOVWF      R0+0
	XORWF      _cnt+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt35
	MOVF       R0+0, 0
	XORWF      _cnt+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt35
	MOVLW      3
	XORWF      _cnt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt35
	MOVF       _cnt+0, 0
	XORLW      232
L__interrupt35:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt8
;nextion.c,127 :: 		cntUser++;
	MOVF       _cntUser+0, 0
	MOVWF      R0+0
	MOVF       _cntUser+1, 0
	MOVWF      R0+1
	MOVF       _cntUser+2, 0
	MOVWF      R0+2
	MOVF       _cntUser+3, 0
	MOVWF      R0+3
	INCF       R0+0, 1
	BTFSC      STATUS+0, 2
	INCF       R0+1, 1
	BTFSC      STATUS+0, 2
	INCF       R0+2, 1
	BTFSC      STATUS+0, 2
	INCF       R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _cntUser+0
	MOVF       R0+1, 0
	MOVWF      _cntUser+1
	MOVF       R0+2, 0
	MOVWF      _cntUser+2
	MOVF       R0+3, 0
	MOVWF      _cntUser+3
;nextion.c,128 :: 		cnt = 0;
	CLRF       _cnt+0
	CLRF       _cnt+1
	CLRF       _cnt+2
	CLRF       _cnt+3
;nextion.c,129 :: 		}
L_interrupt8:
;nextion.c,130 :: 		if(cntUser == tope){//Compara si ya pasó el tiempo que desea el usuario y apaga el módulo T0
	MOVLW      0
	BTFSC      _tope+1, 7
	MOVLW      255
	MOVWF      R0+0
	XORWF      _cntUser+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt36
	MOVF       R0+0, 0
	XORWF      _cntUser+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt36
	MOVF       _tope+1, 0
	XORWF      _cntUser+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt36
	MOVF       _cntUser+0, 0
	XORWF      _tope+0, 0
L__interrupt36:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt9
;nextion.c,131 :: 		flag_end = 1;
	MOVLW      1
	MOVWF      _flag_end+0
	MOVLW      0
	MOVWF      _flag_end+1
;nextion.c,132 :: 		OPTION_REG = 0x00;
	CLRF       OPTION_REG+0
;nextion.c,133 :: 		TMR0 = 0;
	CLRF       TMR0+0
;nextion.c,134 :: 		INTCON = 0x00;
	CLRF       INTCON+0
;nextion.c,135 :: 		}
L_interrupt9:
;nextion.c,136 :: 		}
L_interrupt7:
;nextion.c,137 :: 		}
L_end_interrupt:
L__interrupt34:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_procesa_Rx:

;nextion.c,140 :: 		void procesa_Rx(){
;nextion.c,143 :: 		if(flag_rx == 1){
	MOVF       _flag_rx+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_procesa_Rx10
;nextion.c,144 :: 		for(i=0;i<30;i++){
	CLRF       _i+0
	CLRF       _i+1
L_procesa_Rx11:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesa_Rx38
	MOVLW      30
	SUBWF      _i+0, 0
L__procesa_Rx38:
	BTFSC      STATUS+0, 0
	GOTO       L_procesa_Rx12
;nextion.c,145 :: 		mover_Graph();
	CALL       _mover_Graph+0
;nextion.c,146 :: 		if(trama[i]=='t'){
	MOVF       _i+0, 0
	ADDLW      _trama+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R1+0
	MOVLW      0
	BTFSC      R1+0, 7
	MOVLW      255
	MOVWF      R0+0
	MOVLW      0
	XORWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesa_Rx39
	MOVLW      116
	XORWF      R1+0, 0
L__procesa_Rx39:
	BTFSS      STATUS+0, 2
	GOTO       L_procesa_Rx14
;nextion.c,147 :: 		flag_mv = 1;
	MOVLW      1
	MOVWF      _flag_mv+0
	MOVLW      0
	MOVWF      _flag_mv+1
;nextion.c,148 :: 		flag_end = 1;
	MOVLW      1
	MOVWF      _flag_end+0
	MOVLW      0
	MOVWF      _flag_end+1
;nextion.c,149 :: 		i = 30;
	MOVLW      30
	MOVWF      _i+0
	MOVLW      0
	MOVWF      _i+1
;nextion.c,150 :: 		tope = atoi(trama[2]<<16)+atoi(trama[3]<<8)+atoi(trama[4]);
	CLRF       FARG_atoi_s+0
	CALL       _atoi+0
	MOVF       R0+0, 0
	MOVWF      FLOC__procesa_Rx+0
	MOVF       R0+1, 0
	MOVWF      FLOC__procesa_Rx+1
	MOVF       _trama+3, 0
	MOVWF      R0+1
	CLRF       R0+0
	MOVF       R0+0, 0
	MOVWF      FARG_atoi_s+0
	CALL       _atoi+0
	MOVF       R0+0, 0
	ADDWF      FLOC__procesa_Rx+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      FLOC__procesa_Rx+1, 1
	MOVF       _trama+4, 0
	MOVWF      FARG_atoi_s+0
	CALL       _atoi+0
	MOVF       R0+0, 0
	ADDWF      FLOC__procesa_Rx+0, 0
	MOVWF      _tope+0
	MOVF       FLOC__procesa_Rx+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      _tope+1
;nextion.c,151 :: 		}
L_procesa_Rx14:
;nextion.c,144 :: 		for(i=0;i<30;i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;nextion.c,152 :: 		}
	GOTO       L_procesa_Rx11
L_procesa_Rx12:
;nextion.c,153 :: 		}
L_procesa_Rx10:
;nextion.c,159 :: 		if(strstr(trama,"b=")){
	MOVLW      _trama+0
	MOVWF      FARG_strstr_s1+0
	MOVLW      ?lstr1_nextion+0
	MOVWF      FARG_strstr_s2+0
	CALL       _strstr+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_procesa_Rx15
;nextion.c,160 :: 		der = atoi(trama[2]);
	MOVF       _trama+2, 0
	MOVWF      FARG_atoi_s+0
	CALL       _atoi+0
	MOVF       R0+0, 0
	MOVWF      _der+0
	MOVF       R0+1, 0
	MOVWF      _der+1
;nextion.c,161 :: 		}
L_procesa_Rx15:
;nextion.c,164 :: 		memset(trama,0,30);
	MOVLW      _trama+0
	MOVWF      FARG_memset_p1+0
	CLRF       FARG_memset_character+0
	MOVLW      30
	MOVWF      FARG_memset_n+0
	MOVLW      0
	MOVWF      FARG_memset_n+1
	CALL       _memset+0
;nextion.c,165 :: 		cuenta = 0;  //limpia el contador
	CLRF       _cuenta+0
;nextion.c,166 :: 		flag_rx = 0; //limpia la bandera
	CLRF       _flag_rx+0
;nextion.c,167 :: 		PIR1.F5 = 0; //limpia la bandera de interrpcion
	BCF        PIR1+0, 5
;nextion.c,168 :: 		CREN_bit = 1;
	BSF        CREN_bit+0, BitPos(CREN_bit+0)
;nextion.c,169 :: 		INTCON.F7 = 1;
	BSF        INTCON+0, 7
;nextion.c,171 :: 		}
L_end_procesa_Rx:
	RETURN
; end of _procesa_Rx

_mover_Graph:

;nextion.c,173 :: 		void mover_Graph(){
;nextion.c,174 :: 		for(i = 0; i<255; i++){
	CLRF       _i+0
	CLRF       _i+1
L_mover_Graph16:
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__mover_Graph41
	MOVLW      255
	SUBWF      _i+0, 0
L__mover_Graph41:
	BTFSC      STATUS+0, 0
	GOTO       L_mover_Graph17
;nextion.c,181 :: 		sprinti(envia,"add 8,0,%d",i);
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
;nextion.c,182 :: 		UART1_Write_Text(envia);
	MOVLW      _envia+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;nextion.c,183 :: 		manda_serial_const("\xFF\xFF\xFF");
	MOVLW      ?lstr_3_nextion+0
	MOVWF      FARG_manda_serial_const_info+0
	MOVLW      hi_addr(?lstr_3_nextion+0)
	MOVWF      FARG_manda_serial_const_info+1
	CALL       _manda_serial_const+0
;nextion.c,174 :: 		for(i = 0; i<255; i++){
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;nextion.c,184 :: 		}
	GOTO       L_mover_Graph16
L_mover_Graph17:
;nextion.c,185 :: 		}
L_end_mover_Graph:
	RETURN
; end of _mover_Graph

_Mostrar:

;nextion.c,187 :: 		void Mostrar(){// Dependiendo de la cantidad de muestras almacenadas en EEPROM, las desplegará en la LCD, una cada segundo
;nextion.c,188 :: 		tope = EEPROM_Read(0); // Capacidad de cada dirección EEPROM es de 0 a 255 decimal y hay 0-255 direcciones
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _tope+0
	CLRF       _tope+1
;nextion.c,189 :: 		if(der){
	MOVF       _der+0, 0
	IORWF      _der+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_Mostrar19
;nextion.c,190 :: 		a++;
	INCF       _a+0, 1
	BTFSC      STATUS+0, 2
	INCF       _a+1, 1
;nextion.c,191 :: 		if(a > tope){
	MOVLW      128
	XORWF      _tope+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _a+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar43
	MOVF       _a+0, 0
	SUBWF      _tope+0, 0
L__Mostrar43:
	BTFSC      STATUS+0, 0
	GOTO       L_Mostrar20
;nextion.c,192 :: 		a = tope;
	MOVF       _tope+0, 0
	MOVWF      _a+0
	MOVF       _tope+1, 0
	MOVWF      _a+1
;nextion.c,193 :: 		}
L_Mostrar20:
;nextion.c,194 :: 		}else{
	GOTO       L_Mostrar21
L_Mostrar19:
;nextion.c,195 :: 		a--;
	MOVLW      1
	SUBWF      _a+0, 1
	BTFSS      STATUS+0, 0
	DECF       _a+1, 1
;nextion.c,196 :: 		if(a == (-1)){
	MOVLW      255
	XORWF      _a+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar44
	MOVLW      255
	XORWF      _a+0, 0
L__Mostrar44:
	BTFSS      STATUS+0, 2
	GOTO       L_Mostrar22
;nextion.c,197 :: 		a = 0;
	CLRF       _a+0
	CLRF       _a+1
;nextion.c,198 :: 		}
L_Mostrar22:
;nextion.c,199 :: 		}
L_Mostrar21:
;nextion.c,200 :: 		der = 0;
	CLRF       _der+0
	CLRF       _der+1
;nextion.c,201 :: 		j=a*4;
	MOVF       _a+0, 0
	MOVWF      _j+0
	MOVF       _a+1, 0
	MOVWF      _j+1
	RLF        _j+0, 1
	RLF        _j+1, 1
	BCF        _j+0, 0
	RLF        _j+0, 1
	RLF        _j+1, 1
	BCF        _j+0, 0
;nextion.c,202 :: 		sprinti(envia,"ViewSamples.text0.txt=\"");//para enviar texto
	MOVLW      _envia+0
	MOVWF      FARG_sprinti_wh+0
	MOVLW      ?lstr_4_nextion+0
	MOVWF      FARG_sprinti_f+0
	MOVLW      hi_addr(?lstr_4_nextion+0)
	MOVWF      FARG_sprinti_f+1
	CALL       _sprinti+0
;nextion.c,203 :: 		lect = EEPROM_Read(j++);
	MOVF       _j+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _lect+0
	CLRF       _lect+1
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
;nextion.c,204 :: 		inttostr(lect,envia);
	MOVF       _lect+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _lect+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _envia+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;nextion.c,205 :: 		UART1_Write_Text(envia);
	MOVLW      _envia+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;nextion.c,206 :: 		UART1_Write_Text(".");
	MOVLW      ?lstr5_nextion+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;nextion.c,207 :: 		lect = EEPROM_Read(j++);
	MOVF       _j+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _lect+0
	CLRF       _lect+1
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
;nextion.c,208 :: 		inttostr(lect,envia);
	MOVF       _lect+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _lect+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _envia+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;nextion.c,209 :: 		UART1_Write_Text(envia);
	MOVLW      _envia+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;nextion.c,210 :: 		lect = EEPROM_Read(j++);
	MOVF       _j+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _lect+0
	CLRF       _lect+1
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
;nextion.c,211 :: 		inttostr(lect,envia);
	MOVF       _lect+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _lect+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _envia+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;nextion.c,212 :: 		UART1_Write_Text(envia);
	MOVLW      _envia+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;nextion.c,213 :: 		lect = EEPROM_Read(j++);
	MOVF       _j+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _lect+0
	CLRF       _lect+1
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
;nextion.c,214 :: 		inttostr(lect,envia);
	MOVF       _lect+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       _lect+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _envia+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;nextion.c,215 :: 		UART1_Write_Text(envia);
	MOVLW      _envia+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;nextion.c,216 :: 		UART1_Write_Text("V\"");
	MOVLW      ?lstr6_nextion+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;nextion.c,217 :: 		manda_serial_const("\xFF\xFF\xFF");
	MOVLW      ?lstr_7_nextion+0
	MOVWF      FARG_manda_serial_const_info+0
	MOVLW      hi_addr(?lstr_7_nextion+0)
	MOVWF      FARG_manda_serial_const_info+1
	CALL       _manda_serial_const+0
;nextion.c,218 :: 		}
L_end_Mostrar:
	RETURN
; end of _Mostrar

_GuardarEEPROM:

;nextion.c,220 :: 		void GuardarEEPROM(){
;nextion.c,221 :: 		Voltaje = Voltaje/Tope;
	MOVF       _tope+0, 0
	MOVWF      R4+0
	MOVF       _tope+1, 0
	MOVWF      R4+1
	MOVLW      0
	BTFSC      R4+1, 7
	MOVLW      255
	MOVWF      R4+2
	MOVWF      R4+3
	MOVF       _Voltaje+0, 0
	MOVWF      R0+0
	MOVF       _Voltaje+1, 0
	MOVWF      R0+1
	MOVF       _Voltaje+2, 0
	MOVWF      R0+2
	MOVF       _Voltaje+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _Voltaje+0
	MOVF       R0+1, 0
	MOVWF      _Voltaje+1
	MOVF       R0+2, 0
	MOVWF      _Voltaje+2
	MOVF       R0+3, 0
	MOVWF      _Voltaje+3
;nextion.c,222 :: 		i = EEPROM_Read(0)*4;
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      FLOC__GuardarEEPROM+0
	CLRF       FLOC__GuardarEEPROM+1
	RLF        FLOC__GuardarEEPROM+0, 1
	RLF        FLOC__GuardarEEPROM+1, 1
	BCF        FLOC__GuardarEEPROM+0, 0
	RLF        FLOC__GuardarEEPROM+0, 1
	RLF        FLOC__GuardarEEPROM+1, 1
	BCF        FLOC__GuardarEEPROM+0, 0
	MOVF       FLOC__GuardarEEPROM+0, 0
	MOVWF      _i+0
	MOVF       FLOC__GuardarEEPROM+1, 0
	MOVWF      _i+1
;nextion.c,223 :: 		tlong = (long)Voltaje * 5000;// Convertir el resultado en milivoltios
	MOVF       _Voltaje+0, 0
	MOVWF      R0+0
	MOVF       _Voltaje+1, 0
	MOVWF      R0+1
	MOVF       _Voltaje+2, 0
	MOVWF      R0+2
	MOVF       _Voltaje+3, 0
	MOVWF      R0+3
	MOVLW      136
	MOVWF      R4+0
	MOVLW      19
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _tlong+0
	MOVF       R0+1, 0
	MOVWF      _tlong+1
	MOVF       R0+2, 0
	MOVWF      _tlong+2
	MOVF       R0+3, 0
	MOVWF      _tlong+3
;nextion.c,224 :: 		tlong = tlong / 1023;        // 0..1023 -> 0-5000mV
	MOVLW      255
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _tlong+0
	MOVF       R0+1, 0
	MOVWF      _tlong+1
	MOVF       R0+2, 0
	MOVWF      _tlong+2
	MOVF       R0+3, 0
	MOVWF      _tlong+3
;nextion.c,225 :: 		ch = tlong / 1000;           // Extraer voltios (miles de milivoltios)
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _ch+0
;nextion.c,227 :: 		EEPROM_Write(++i,ch);        //
	MOVF       FLOC__GuardarEEPROM+0, 0
	ADDLW      1
	MOVWF      R4+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      FLOC__GuardarEEPROM+1, 0
	MOVWF      R4+1
	MOVF       R4+0, 0
	MOVWF      _i+0
	MOVF       R4+1, 0
	MOVWF      _i+1
	MOVF       R4+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;nextion.c,228 :: 		Delay_ms(20);
	MOVLW      104
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_GuardarEEPROM23:
	DECFSZ     R13+0, 1
	GOTO       L_GuardarEEPROM23
	DECFSZ     R12+0, 1
	GOTO       L_GuardarEEPROM23
	NOP
;nextion.c,229 :: 		ch = (tlong / 100) % 10;     // Extraer centenas de milivoltios
	MOVLW      100
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _tlong+0, 0
	MOVWF      R0+0
	MOVF       _tlong+1, 0
	MOVWF      R0+1
	MOVF       _tlong+2, 0
	MOVWF      R0+2
	MOVF       _tlong+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      _ch+0
;nextion.c,230 :: 		EEPROM_Write(++i,ch);
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
	MOVF       _i+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;nextion.c,231 :: 		Delay_ms(20);
	MOVLW      104
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_GuardarEEPROM24:
	DECFSZ     R13+0, 1
	GOTO       L_GuardarEEPROM24
	DECFSZ     R12+0, 1
	GOTO       L_GuardarEEPROM24
	NOP
;nextion.c,232 :: 		ch = (tlong / 10) % 10;      // Extraer decenas de milivoltios
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _tlong+0, 0
	MOVWF      R0+0
	MOVF       _tlong+1, 0
	MOVWF      R0+1
	MOVF       _tlong+2, 0
	MOVWF      R0+2
	MOVF       _tlong+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      _ch+0
;nextion.c,233 :: 		EEPROM_Write(++i,ch);
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
	MOVF       _i+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;nextion.c,234 :: 		Delay_ms(20);
	MOVLW      104
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_GuardarEEPROM25:
	DECFSZ     R13+0, 1
	GOTO       L_GuardarEEPROM25
	DECFSZ     R12+0, 1
	GOTO       L_GuardarEEPROM25
	NOP
;nextion.c,235 :: 		ch = tlong % 10;             // Extraer unidades de milivoltios
	MOVLW      10
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	MOVF       _tlong+0, 0
	MOVWF      R0+0
	MOVF       _tlong+1, 0
	MOVWF      R0+1
	MOVF       _tlong+2, 0
	MOVWF      R0+2
	MOVF       _tlong+3, 0
	MOVWF      R0+3
	CALL       _Div_32x32_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R8+2, 0
	MOVWF      R0+2
	MOVF       R8+3, 0
	MOVWF      R0+3
	MOVF       R0+0, 0
	MOVWF      _ch+0
;nextion.c,236 :: 		EEPROM_Write(++i,ch);
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
	MOVF       _i+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;nextion.c,237 :: 		Delay_ms(20);
	MOVLW      104
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_GuardarEEPROM26:
	DECFSZ     R13+0, 1
	GOTO       L_GuardarEEPROM26
	DECFSZ     R12+0, 1
	GOTO       L_GuardarEEPROM26
	NOP
;nextion.c,238 :: 		ch = EEPROM_Read(0);         // Extrae de la dirección 0 de EEPROM, que es la cantidad de muestras que
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _ch+0
;nextion.c,239 :: 		ch++;                        //
	INCF       R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _ch+0
;nextion.c,240 :: 		EEPROM_Write(0,ch);
	CLRF       FARG_EEPROM_Write_Address+0
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;nextion.c,241 :: 		Voltaje = 0;                 // Resetea Voltaje, porque ya lo almacenó en EEPROM
	CLRF       _Voltaje+0
	CLRF       _Voltaje+1
	CLRF       _Voltaje+2
	CLRF       _Voltaje+3
;nextion.c,242 :: 		}
L_end_GuardarEEPROM:
	RETURN
; end of _GuardarEEPROM

_main:

;nextion.c,244 :: 		void main(){
;nextion.c,245 :: 		ANSEL = 255;                           //Pines analogicos del puerto A, B desactivados
	MOVLW      255
	MOVWF      ANSEL+0
;nextion.c,246 :: 		ANSELH = 0;                          //Pines analogicos del puerto E desactivados
	CLRF       ANSELH+0
;nextion.c,247 :: 		TRISA = 0b00001101;
	MOVLW      13
	MOVWF      TRISA+0
;nextion.c,248 :: 		TRISB = 0;
	CLRF       TRISB+0
;nextion.c,249 :: 		TRISC = 0b10000000;//entrada pin RX  salida pin TX
	MOVLW      128
	MOVWF      TRISC+0
;nextion.c,250 :: 		TRISD = 0;
	CLRF       TRISD+0
;nextion.c,251 :: 		TRISE = 0;
	CLRF       TRISE+0
;nextion.c,252 :: 		PORTA = 0;
	CLRF       PORTA+0
;nextion.c,253 :: 		PORTD = 0;
	CLRF       PORTD+0
;nextion.c,254 :: 		PORTC = 0;
	CLRF       PORTC+0
;nextion.c,255 :: 		PORTB = 0;
	CLRF       PORTB+0
;nextion.c,256 :: 		PORTE = 0;
	CLRF       PORTE+0
;nextion.c,257 :: 		resetALL();
	CALL       _resetAll+0
;nextion.c,258 :: 		UART1_Init(9600);
	MOVLW      103
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;nextion.c,259 :: 		ADC_Init();
	CALL       _ADC_Init+0
;nextion.c,261 :: 		PIR1.F5 = 0;
	BCF        PIR1+0, 5
;nextion.c,262 :: 		PIE1.F5 = 1;
	BSF        PIE1+0, 5
;nextion.c,263 :: 		INTCON.F6 = 1;
	BSF        INTCON+0, 6
;nextion.c,264 :: 		INTCON.F7 = 1;
	BSF        INTCON+0, 7
;nextion.c,265 :: 		manda_serial_const("cle 8,0");
	MOVLW      ?lstr_8_nextion+0
	MOVWF      FARG_manda_serial_const_info+0
	MOVLW      hi_addr(?lstr_8_nextion+0)
	MOVWF      FARG_manda_serial_const_info+1
	CALL       _manda_serial_const+0
;nextion.c,266 :: 		manda_serial_const("\xFF\xFF\xFF");
	MOVLW      ?lstr_9_nextion+0
	MOVWF      FARG_manda_serial_const_info+0
	MOVLW      hi_addr(?lstr_9_nextion+0)
	MOVWF      FARG_manda_serial_const_info+1
	CALL       _manda_serial_const+0
;nextion.c,267 :: 		while(1){
L_main27:
;nextion.c,268 :: 		procesa_Rx();
	CALL       _procesa_Rx+0
;nextion.c,296 :: 		}
	GOTO       L_main27
;nextion.c,297 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
