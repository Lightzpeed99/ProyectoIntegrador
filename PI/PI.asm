
_resetAll:

;PI.c,55 :: 		void resetAll(){       //Se resetean todas las variables
;PI.c,56 :: 		banderaUp = 0;
	CLRF       _banderaUp+0
;PI.c,57 :: 		banderaOk = 0;
	CLRF       _banderaOk+0
;PI.c,58 :: 		banderaDown = 0;
	CLRF       _banderaDown+0
;PI.c,59 :: 		opcion = 0;
	CLRF       _opcion+0
	CLRF       _opcion+1
;PI.c,60 :: 		lect = 0;
	CLRF       _lect+0
	CLRF       _lect+1
;PI.c,61 :: 		valor = 0;
	CLRF       _valor+0
	CLRF       _valor+1
;PI.c,62 :: 		cnt =0;
	CLRF       _cnt+0
	CLRF       _cnt+1
	CLRF       _cnt+2
	CLRF       _cnt+3
;PI.c,63 :: 		tiempo = 0;
	CLRF       _tiempo+0
	CLRF       _tiempo+1
	CLRF       _tiempo+2
	CLRF       _tiempo+3
;PI.c,64 :: 		cntUser = 0;
	CLRF       _cntUser+0
	CLRF       _cntUser+1
	CLRF       _cntUser+2
	CLRF       _cntUser+3
;PI.c,65 :: 		segundos = 0;
	CLRF       _segundos+0
	CLRF       _segundos+1
;PI.c,66 :: 		minutos = 0;
	CLRF       _minutos+0
	CLRF       _minutos+1
;PI.c,67 :: 		horas = 0;
	CLRF       _horas+0
	CLRF       _horas+1
;PI.c,68 :: 		timing = 0;
	CLRF       _timing+0
;PI.c,69 :: 		decena = 0;
	CLRF       _decena+0
;PI.c,70 :: 		espacio = 0;
	CLRF       _espacio+0
;PI.c,71 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;PI.c,72 :: 		tope = 0;
	CLRF       _tope+0
	CLRF       _tope+1
	CLRF       _tope+2
	CLRF       _tope+3
;PI.c,73 :: 		j = 0;
	CLRF       _j+0
	CLRF       _j+1
;PI.c,74 :: 		desp = 0;
	CLRF       _desp+0
	CLRF       _desp+1
;PI.c,75 :: 		}
L_end_resetAll:
	RETURN
; end of _resetAll

_initTMR0:

;PI.c,76 :: 		void initTMR0(){//Arranca el TMR0
;PI.c,77 :: 		OPTION_REG = 0x82;
	MOVLW      130
	MOVWF      OPTION_REG+0
;PI.c,78 :: 		TMR0  = 6;
	MOVLW      6
	MOVWF      TMR0+0
;PI.c,79 :: 		INTCON = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;PI.c,80 :: 		}
L_end_initTMR0:
	RETURN
; end of _initTMR0

_procesarValor:

;PI.c,83 :: 		void procesarValor(int opc){
;PI.c,84 :: 		espacio = 48+valor;
	MOVF       _valor+0, 0
	ADDLW      48
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      _espacio+0
;PI.c,85 :: 		if(espacio == 58){//si valor excede el 9, significa que se hará uso del espacio en blanco a la derecha
	MOVF       R1+0, 0
	XORLW      58
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor0
;PI.c,87 :: 		valor = 0;
	CLRF       _valor+0
	CLRF       _valor+1
;PI.c,88 :: 		if(desp==0){//cuando sucede esto por primera vez, la variable decena trae el valor de -16, pero ahora se
	MOVLW      0
	XORWF      _desp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor109
	MOVLW      0
	XORWF      _desp+0, 0
L__procesarValor109:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor1
;PI.c,90 :: 		decena = 0;
	CLRF       _decena+0
;PI.c,91 :: 		desp = 1; //desplazamiento se activa, para que más adelante la decena no se vuelva -16
	MOVLW      1
	MOVWF      _desp+0
	MOVLW      0
	MOVWF      _desp+1
;PI.c,92 :: 		}
L_procesarValor1:
;PI.c,93 :: 		decena++;
	INCF       _decena+0, 1
;PI.c,94 :: 		}
L_procesarValor0:
;PI.c,95 :: 		if(espacio == 47){//si se trata de decrementar al valor de 0, este se irá a su límite superior
	MOVF       _espacio+0, 0
	XORLW      47
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor2
;PI.c,96 :: 		valor = 9;
	MOVLW      9
	MOVWF      _valor+0
	MOVLW      0
	MOVWF      _valor+1
;PI.c,97 :: 		if(desp == 1){//cuando desplazamiento esté activado, significa que hay decenas cargadas, por lo tanto
	MOVLW      0
	XORWF      _desp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor110
	MOVLW      1
	XORWF      _desp+0, 0
L__procesarValor110:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor3
;PI.c,99 :: 		decena--;
	DECF       _decena+0, 1
;PI.c,100 :: 		if(decena == 0){//si la decena llega a 0, 'desp'lazamient se vuelve 0, para que adquiera el valor de -16
	MOVF       _decena+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor4
;PI.c,102 :: 		desp = 0;
	CLRF       _desp+0
	CLRF       _desp+1
;PI.c,103 :: 		}
L_procesarValor4:
;PI.c,104 :: 		}
L_procesarValor3:
;PI.c,105 :: 		}
L_procesarValor2:
;PI.c,106 :: 		switch(opc){
	GOTO       L_procesarValor5
;PI.c,107 :: 		case 1://horas
L_procesarValor7:
;PI.c,108 :: 		Lcd_Chr(1,13,decena+48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _decena+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,109 :: 		Lcd_Chr(1,14,48+valor);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _valor+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,110 :: 		horas = decena*10+valor;
	MOVF       _decena+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_S+0
	MOVF       _valor+0, 0
	ADDWF      R0+0, 0
	MOVWF      _horas+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _valor+1, 0
	MOVWF      _horas+1
;PI.c,111 :: 		break;
	GOTO       L_procesarValor6
;PI.c,112 :: 		case 2://minutos
L_procesarValor8:
;PI.c,113 :: 		Lcd_Chr(2,5,decena+48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _decena+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,114 :: 		Lcd_Chr(2,6,48+valor);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _valor+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,115 :: 		minutos = decena*10+valor;
	MOVF       _decena+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_S+0
	MOVF       _valor+0, 0
	ADDWF      R0+0, 0
	MOVWF      _minutos+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _valor+1, 0
	MOVWF      _minutos+1
;PI.c,116 :: 		break;
	GOTO       L_procesarValor6
;PI.c,117 :: 		case 3://horas
L_procesarValor9:
;PI.c,118 :: 		Lcd_Chr(2,13,decena+48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _decena+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,119 :: 		Lcd_Chr(2,14,48+valor);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _valor+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,120 :: 		segundos = decena*10+valor;
	MOVF       _decena+0, 0
	MOVWF      R0+0
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_S+0
	MOVF       _valor+0, 0
	ADDWF      R0+0, 0
	MOVWF      _segundos+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _valor+1, 0
	MOVWF      _segundos+1
;PI.c,121 :: 		break;
	GOTO       L_procesarValor6
;PI.c,122 :: 		}
L_procesarValor5:
	MOVLW      0
	XORWF      FARG_procesarValor_opc+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor111
	MOVLW      1
	XORWF      FARG_procesarValor_opc+0, 0
L__procesarValor111:
	BTFSC      STATUS+0, 2
	GOTO       L_procesarValor7
	MOVLW      0
	XORWF      FARG_procesarValor_opc+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor112
	MOVLW      2
	XORWF      FARG_procesarValor_opc+0, 0
L__procesarValor112:
	BTFSC      STATUS+0, 2
	GOTO       L_procesarValor8
	MOVLW      0
	XORWF      FARG_procesarValor_opc+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor113
	MOVLW      3
	XORWF      FARG_procesarValor_opc+0, 0
L__procesarValor113:
	BTFSC      STATUS+0, 2
	GOTO       L_procesarValor9
L_procesarValor6:
;PI.c,123 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_procesarValor10:
	DECFSZ     R13+0, 1
	GOTO       L_procesarValor10
	DECFSZ     R12+0, 1
	GOTO       L_procesarValor10
	DECFSZ     R11+0, 1
	GOTO       L_procesarValor10
	NOP
;PI.c,124 :: 		}
L_end_procesarValor:
	RETURN
; end of _procesarValor

_cnfTiempoLcd:

;PI.c,126 :: 		void cnfTiempoLcd(){//Captura tiempo a muestrear (TMR0)
;PI.c,127 :: 		timing = 1;
	MOVLW      1
	MOVWF      _timing+0
;PI.c,128 :: 		desp = 0;
	CLRF       _desp+0
	CLRF       _desp+1
;PI.c,129 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PI.c,132 :: 		Lcd_Out(1,1,"Tiempo: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,133 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd11:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd11
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd11
	NOP
	NOP
;PI.c,134 :: 		Lcd_Out(1,9,"Hrs[  ]");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,135 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd12:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd12
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd12
	NOP
	NOP
;PI.c,136 :: 		Lcd_Out(2,1,"Min[  ]");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,137 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd13:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd13
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd13
	NOP
	NOP
;PI.c,138 :: 		Lcd_Out(2,9,"Seg[  ]");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,139 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd14:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd14
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd14
	NOP
	NOP
;PI.c,140 :: 		valor = 0;
	CLRF       _valor+0
	CLRF       _valor+1
;PI.c,141 :: 		while(timing != 4){//timing sirve para saber en qué unidad de tiempo se está ajustando el parámetro
L_cnfTiempoLcd15:
	MOVF       _timing+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_cnfTiempoLcd16
;PI.c,142 :: 		if(UPBtn && banderaUp==0){//incrementa unidades de tiempo con el botón de UP
	BTFSS      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_cnfTiempoLcd19
	MOVF       _banderaUp+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd19
L__cnfTiempoLcd99:
;PI.c,143 :: 		banderaUp = 1;
	MOVLW      1
	MOVWF      _banderaUp+0
;PI.c,144 :: 		valor++;
	INCF       _valor+0, 1
	BTFSC      STATUS+0, 2
	INCF       _valor+1, 1
;PI.c,145 :: 		procesarValor(timing);//dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
	MOVF       _timing+0, 0
	MOVWF      FARG_procesarValor_opc+0
	MOVLW      0
	BTFSC      FARG_procesarValor_opc+0, 7
	MOVLW      255
	MOVWF      FARG_procesarValor_opc+1
	CALL       _procesarValor+0
;PI.c,146 :: 		}
L_cnfTiempoLcd19:
;PI.c,147 :: 		if(!UPBtn && banderaUp==1){
	BTFSC      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_cnfTiempoLcd22
	MOVF       _banderaUp+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd22
L__cnfTiempoLcd98:
;PI.c,148 :: 		banderaUp=0;
	CLRF       _banderaUp+0
;PI.c,149 :: 		}
L_cnfTiempoLcd22:
;PI.c,150 :: 		if(OKBtn && banderaOk==0){//Se acepta el valor cargado en las unidades de tiempo, se incrementa al siguiente
	BTFSS      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L_cnfTiempoLcd25
	MOVF       _banderaOk+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd25
L__cnfTiempoLcd97:
;PI.c,152 :: 		timing++;
	INCF       _timing+0, 1
;PI.c,153 :: 		banderaOk = 1;
	MOVLW      1
	MOVWF      _banderaOk+0
;PI.c,154 :: 		decena = 0;
	CLRF       _decena+0
;PI.c,155 :: 		valor = 0;
	CLRF       _valor+0
	CLRF       _valor+1
;PI.c,156 :: 		desp = 0;
	CLRF       _desp+0
	CLRF       _desp+1
;PI.c,157 :: 		}
L_cnfTiempoLcd25:
;PI.c,158 :: 		if(!OKBtn && banderaOk==1){
	BTFSC      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L_cnfTiempoLcd28
	MOVF       _banderaOk+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd28
L__cnfTiempoLcd96:
;PI.c,159 :: 		banderaOk=0;
	CLRF       _banderaOk+0
;PI.c,160 :: 		switch(timing){
	GOTO       L_cnfTiempoLcd29
;PI.c,161 :: 		case 2:
L_cnfTiempoLcd31:
;PI.c,162 :: 		if(horas==0){
	MOVLW      0
	XORWF      _horas+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd115
	MOVLW      0
	XORWF      _horas+0, 0
L__cnfTiempoLcd115:
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd32
;PI.c,163 :: 		Lcd_Chr(1,13,'0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,164 :: 		Lcd_Chr(1,14,'0');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,165 :: 		}
L_cnfTiempoLcd32:
;PI.c,166 :: 		break;
	GOTO       L_cnfTiempoLcd30
;PI.c,167 :: 		case 3:if(minutos == 0){
L_cnfTiempoLcd33:
	MOVLW      0
	XORWF      _minutos+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd116
	MOVLW      0
	XORWF      _minutos+0, 0
L__cnfTiempoLcd116:
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd34
;PI.c,168 :: 		Lcd_Chr(2,5,'0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,169 :: 		Lcd_Chr(2,6,'0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,170 :: 		}/**/
L_cnfTiempoLcd34:
;PI.c,171 :: 		break;
	GOTO       L_cnfTiempoLcd30
;PI.c,172 :: 		case 4:
L_cnfTiempoLcd35:
;PI.c,173 :: 		if(segundos == 0){
	MOVLW      0
	XORWF      _segundos+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd117
	MOVLW      0
	XORWF      _segundos+0, 0
L__cnfTiempoLcd117:
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd36
;PI.c,174 :: 		Lcd_Chr(2,13,'0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,175 :: 		Lcd_Chr(2,14,'0');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,176 :: 		}
L_cnfTiempoLcd36:
;PI.c,177 :: 		break;
	GOTO       L_cnfTiempoLcd30
;PI.c,178 :: 		}
L_cnfTiempoLcd29:
	MOVF       _timing+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_cnfTiempoLcd31
	MOVF       _timing+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_cnfTiempoLcd33
	MOVF       _timing+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_cnfTiempoLcd35
L_cnfTiempoLcd30:
;PI.c,179 :: 		}
L_cnfTiempoLcd28:
;PI.c,180 :: 		if(DOWNBtn && banderaDown==0){//Decrementa unidades de tiempo con el botón Down
	BTFSS      RC2_bit+0, BitPos(RC2_bit+0)
	GOTO       L_cnfTiempoLcd39
	MOVF       _banderaDown+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd39
L__cnfTiempoLcd95:
;PI.c,181 :: 		banderaDown = 1;
	MOVLW      1
	MOVWF      _banderaDown+0
;PI.c,182 :: 		valor--;
	MOVLW      1
	SUBWF      _valor+0, 1
	BTFSS      STATUS+0, 0
	DECF       _valor+1, 1
;PI.c,183 :: 		procesarValor(timing);//Dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
	MOVF       _timing+0, 0
	MOVWF      FARG_procesarValor_opc+0
	MOVLW      0
	BTFSC      FARG_procesarValor_opc+0, 7
	MOVLW      255
	MOVWF      FARG_procesarValor_opc+1
	CALL       _procesarValor+0
;PI.c,184 :: 		}
L_cnfTiempoLcd39:
;PI.c,185 :: 		if(!DOWNBtn && banderaDown==1){
	BTFSC      RC2_bit+0, BitPos(RC2_bit+0)
	GOTO       L_cnfTiempoLcd42
	MOVF       _banderaDown+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd42
L__cnfTiempoLcd94:
;PI.c,186 :: 		banderaDown=0;
	CLRF       _banderaDown+0
;PI.c,187 :: 		}
L_cnfTiempoLcd42:
;PI.c,188 :: 		}
	GOTO       L_cnfTiempoLcd15
L_cnfTiempoLcd16:
;PI.c,189 :: 		tope = horas*360+minutos*60+segundos;
	MOVF       _horas+0, 0
	MOVWF      R0+0
	MOVF       _horas+1, 0
	MOVWF      R0+1
	MOVLW      104
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__cnfTiempoLcd+0
	MOVF       R0+1, 0
	MOVWF      FLOC__cnfTiempoLcd+1
	MOVF       _minutos+0, 0
	MOVWF      R0+0
	MOVF       _minutos+1, 0
	MOVWF      R0+1
	MOVLW      60
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	ADDWF      FLOC__cnfTiempoLcd+0, 0
	MOVWF      _tope+0
	MOVF       FLOC__cnfTiempoLcd+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R0+1, 0
	MOVWF      _tope+1
	MOVF       _segundos+0, 0
	ADDWF      _tope+0, 1
	MOVF       _segundos+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _tope+1, 1
	MOVLW      0
	MOVWF      _tope+2
	MOVWF      _tope+3
;PI.c,190 :: 		}
L_end_cnfTiempoLcd:
	RETURN
; end of _cnfTiempoLcd

_GuardarEEPROM:

;PI.c,192 :: 		void GuardarEEPROM(){
;PI.c,193 :: 		i = EEPROM_Read(0)*4;
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _i+0
	CLRF       _i+1
	RLF        _i+0, 1
	RLF        _i+1, 1
	BCF        _i+0, 0
	RLF        _i+0, 1
	RLF        _i+1, 1
	BCF        _i+0, 0
;PI.c,198 :: 		tlong = (long)Voltaje * 5000; // Convertir el resultado en milivoltios
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
;PI.c,199 :: 		tlong = tlong / 1023;        // 0..1023 -> 0-5000mV
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
;PI.c,200 :: 		ch = tlong / 1000;           // Extraer voltios (miles de milivoltios)
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Div_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _ch+0
;PI.c,202 :: 		Lcd_Chr(2,9,48+ch);          // Escribir resultado en formato ASCII
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,203 :: 		EEPROM_Write(++i,ch);
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
	MOVF       _i+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _ch+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;PI.c,204 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_GuardarEEPROM43:
	DECFSZ     R13+0, 1
	GOTO       L_GuardarEEPROM43
	DECFSZ     R12+0, 1
	GOTO       L_GuardarEEPROM43
	NOP
	NOP
;PI.c,205 :: 		Lcd_Chr_CP('.');
	MOVLW      46
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,206 :: 		ch = (tlong / 100) % 10;     // Extraer centenas de milivoltios
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
;PI.c,207 :: 		Lcd_Chr_CP(48+ch);           // Escribir resultado en formato ASCII
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,208 :: 		EEPROM_Write(++i,ch);
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
	MOVF       _i+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _ch+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;PI.c,209 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_GuardarEEPROM44:
	DECFSZ     R13+0, 1
	GOTO       L_GuardarEEPROM44
	DECFSZ     R12+0, 1
	GOTO       L_GuardarEEPROM44
	NOP
	NOP
;PI.c,210 :: 		ch = (tlong / 10) % 10;      // Extraer decenas de milivoltios
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
;PI.c,211 :: 		Lcd_Chr_CP(48+ch);           // Escribir resultado en formato ASCII
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,212 :: 		EEPROM_Write(++i,ch);
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
	MOVF       _i+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _ch+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;PI.c,213 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_GuardarEEPROM45:
	DECFSZ     R13+0, 1
	GOTO       L_GuardarEEPROM45
	DECFSZ     R12+0, 1
	GOTO       L_GuardarEEPROM45
	NOP
	NOP
;PI.c,214 :: 		ch = tlong % 10;             // Extraer unidades de milivoltios
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
;PI.c,215 :: 		Lcd_Chr_CP(48+ch);           // Escribir resultado en formato ASCII
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,216 :: 		EEPROM_Write(++i,ch);
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
	MOVF       _i+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _ch+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;PI.c,217 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_GuardarEEPROM46:
	DECFSZ     R13+0, 1
	GOTO       L_GuardarEEPROM46
	DECFSZ     R12+0, 1
	GOTO       L_GuardarEEPROM46
	NOP
	NOP
;PI.c,218 :: 		Lcd_Chr_CP('V');
	MOVLW      86
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,219 :: 		ch = EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _ch+0
;PI.c,220 :: 		ch++;
	INCF       R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _ch+0
;PI.c,221 :: 		EEPROM_Write(0,ch);
	CLRF       FARG_EEPROM_Write_Address+0
	MOVF       R0+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;PI.c,222 :: 		Delay_ms(2000);
	MOVLW      21
	MOVWF      R11+0
	MOVLW      75
	MOVWF      R12+0
	MOVLW      190
	MOVWF      R13+0
L_GuardarEEPROM47:
	DECFSZ     R13+0, 1
	GOTO       L_GuardarEEPROM47
	DECFSZ     R12+0, 1
	GOTO       L_GuardarEEPROM47
	DECFSZ     R11+0, 1
	GOTO       L_GuardarEEPROM47
	NOP
;PI.c,223 :: 		}
L_end_GuardarEEPROM:
	RETURN
; end of _GuardarEEPROM

_Muestrear:

;PI.c,225 :: 		void Muestrear(){//Dentro del while, la i representa el tiempo que se irá incrementando en la interrupción del
;PI.c,228 :: 		RB0_bit = ~RB0_bit;
	MOVLW
	XORWF      RB0_bit+0, 1
;PI.c,229 :: 		LongToStr(Voltaje,text);
	MOVF       _Voltaje+0, 0
	MOVWF      FARG_LongToStr_input+0
	MOVF       _Voltaje+1, 0
	MOVWF      FARG_LongToStr_input+1
	MOVF       _Voltaje+2, 0
	MOVWF      FARG_LongToStr_input+2
	MOVF       _Voltaje+3, 0
	MOVWF      FARG_LongToStr_input+3
	MOVLW      _text+0
	MOVWF      FARG_LongToStr_output+0
	CALL       _LongToStr+0
;PI.c,230 :: 		UART1_Write_Text(text);
	MOVLW      _text+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,231 :: 		UART1_Write_Text("\r\n");
	MOVLW      ?lstr5_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,232 :: 		Voltaje+=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVLW      0
	MOVWF      R0+2
	MOVWF      R0+3
	MOVF       _Voltaje+0, 0
	ADDWF      R0+0, 1
	MOVF       _Voltaje+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _Voltaje+1, 0
	ADDWF      R0+1, 1
	MOVF       _Voltaje+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _Voltaje+2, 0
	ADDWF      R0+2, 1
	MOVF       _Voltaje+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     _Voltaje+3, 0
	ADDWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      _Voltaje+0
	MOVF       R0+1, 0
	MOVWF      _Voltaje+1
	MOVF       R0+2, 0
	MOVWF      _Voltaje+2
	MOVF       R0+3, 0
	MOVWF      _Voltaje+3
;PI.c,233 :: 		}
L_end_Muestrear:
	RETURN
; end of _Muestrear

_Mostrar:

;PI.c,235 :: 		void Mostrar(){//Dentro del while, la i representa el índice de la memoria eeprom que se irá incrementando cada que
;PI.c,239 :: 		Lcd_Out(1,1,"Mostrando data");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,240 :: 		delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_Mostrar48:
	DECFSZ     R13+0, 1
	GOTO       L_Mostrar48
	DECFSZ     R12+0, 1
	GOTO       L_Mostrar48
	DECFSZ     R11+0, 1
	GOTO       L_Mostrar48
	NOP
	NOP
;PI.c,241 :: 		tope = EEPROM_Read(0); // capacidad es de 0 a 255 decimal
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _tope+0
	CLRF       _tope+1
	CLRF       _tope+2
	CLRF       _tope+3
;PI.c,242 :: 		UART1_Write_Text("\r\n");
	MOVLW      ?lstr7_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,243 :: 		UART1_Write_Text("Tope:");
	MOVLW      ?lstr8_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,244 :: 		LongToStr(tope,txtLong);
	MOVF       _tope+0, 0
	MOVWF      FARG_LongToStr_input+0
	MOVF       _tope+1, 0
	MOVWF      FARG_LongToStr_input+1
	MOVF       _tope+2, 0
	MOVWF      FARG_LongToStr_input+2
	MOVF       _tope+3, 0
	MOVWF      FARG_LongToStr_input+3
	MOVLW      _txtLong+0
	MOVWF      FARG_LongToStr_output+0
	CALL       _LongToStr+0
;PI.c,245 :: 		UART1_Write_Text(txtLong);
	MOVLW      _txtLong+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,247 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;PI.c,248 :: 		j = 1;//se va moviendo en las direcciones de eeprom 1-255 direcciones, Inicia en 1, porque la direccion 0
	MOVLW      1
	MOVWF      _j+0
	MOVLW      0
	MOVWF      _j+1
;PI.c,250 :: 		VoltInt = 0;
	CLRF       _VoltInt+0
	CLRF       _VoltInt+1
;PI.c,251 :: 		cnt = 6;
	MOVLW      6
	MOVWF      _cnt+0
	CLRF       _cnt+1
	CLRF       _cnt+2
	CLRF       _cnt+3
;PI.c,252 :: 		while(i<tope){
L_Mostrar49:
	MOVLW      0
	BTFSC      _i+1, 7
	MOVLW      255
	MOVWF      R0+0
	MOVF       _tope+3, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar121
	MOVLW      0
	BTFSC      _i+1, 7
	MOVLW      255
	MOVWF      R0+0
	MOVF       _tope+2, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar121
	MOVF       _tope+1, 0
	SUBWF      _i+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar121
	MOVF       _tope+0, 0
	SUBWF      _i+0, 0
L__Mostrar121:
	BTFSC      STATUS+0, 0
	GOTO       L_Mostrar50
;PI.c,253 :: 		lect = EEPROM_Read(j);
	MOVF       _j+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _lect+0
	CLRF       _lect+1
;PI.c,254 :: 		j++;
	INCF       _j+0, 1
	BTFSC      STATUS+0, 2
	INCF       _j+1, 1
;PI.c,255 :: 		VoltInt++;
	INCF       _VoltInt+0, 1
	BTFSC      STATUS+0, 2
	INCF       _VoltInt+1, 1
;PI.c,256 :: 		cnt++;
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
;PI.c,257 :: 		if(VoltInt != 6 && VoltInt != 2){
	MOVLW      0
	XORWF      _VoltInt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar122
	MOVLW      6
	XORWF      _VoltInt+0, 0
L__Mostrar122:
	BTFSC      STATUS+0, 2
	GOTO       L_Mostrar53
	MOVLW      0
	XORWF      _VoltInt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar123
	MOVLW      2
	XORWF      _VoltInt+0, 0
L__Mostrar123:
	BTFSC      STATUS+0, 2
	GOTO       L_Mostrar53
L__Mostrar100:
;PI.c,258 :: 		Lcd_Chr(2,cnt,lect+48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _cnt+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _lect+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,260 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_Mostrar54:
	DECFSZ     R13+0, 1
	GOTO       L_Mostrar54
	DECFSZ     R12+0, 1
	GOTO       L_Mostrar54
	NOP
	NOP
;PI.c,261 :: 		}else if(VoltInt==2){
	GOTO       L_Mostrar55
L_Mostrar53:
	MOVLW      0
	XORWF      _VoltInt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar124
	MOVLW      2
	XORWF      _VoltInt+0, 0
L__Mostrar124:
	BTFSS      STATUS+0, 2
	GOTO       L_Mostrar56
;PI.c,262 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_Mostrar57:
	DECFSZ     R13+0, 1
	GOTO       L_Mostrar57
	DECFSZ     R12+0, 1
	GOTO       L_Mostrar57
	NOP
	NOP
;PI.c,263 :: 		Lcd_Chr(2,cnt,'.');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _cnt+0, 0
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      46
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,264 :: 		j--; //como se colocó un punto y no un valor de eeprom, el incremento se anula con un decremento
	MOVLW      1
	SUBWF      _j+0, 1
	BTFSS      STATUS+0, 0
	DECF       _j+1, 1
;PI.c,267 :: 		}else{//VoltInt == 6
	GOTO       L_Mostrar58
L_Mostrar56:
;PI.c,268 :: 		i++;
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;PI.c,269 :: 		j--;
	MOVLW      1
	SUBWF      _j+0, 1
	BTFSS      STATUS+0, 0
	DECF       _j+1, 1
;PI.c,270 :: 		Lcd_Chr_CP('V');
	MOVLW      86
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,271 :: 		cnt = 6;
	MOVLW      6
	MOVWF      _cnt+0
	CLRF       _cnt+1
	CLRF       _cnt+2
	CLRF       _cnt+3
;PI.c,272 :: 		VoltInt = 0;
	CLRF       _VoltInt+0
	CLRF       _VoltInt+1
;PI.c,274 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_Mostrar59:
	DECFSZ     R13+0, 1
	GOTO       L_Mostrar59
	DECFSZ     R12+0, 1
	GOTO       L_Mostrar59
	DECFSZ     R11+0, 1
	GOTO       L_Mostrar59
	NOP
	NOP
;PI.c,275 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PI.c,276 :: 		Lcd_Out(1,1,"Mostrando data");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,277 :: 		}
L_Mostrar58:
L_Mostrar55:
;PI.c,279 :: 		}
	GOTO       L_Mostrar49
L_Mostrar50:
;PI.c,280 :: 		}
L_end_Mostrar:
	RETURN
; end of _Mostrar

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;PI.c,282 :: 		void interrupt(){
;PI.c,283 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_interrupt60
;PI.c,284 :: 		cnt++;
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
;PI.c,285 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;PI.c,286 :: 		TMR0 = 6;
	MOVLW      6
	MOVWF      TMR0+0
;PI.c,287 :: 		if(cnt>1000){
	MOVF       _cnt+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt127
	MOVF       _cnt+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt127
	MOVF       _cnt+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt127
	MOVF       _cnt+0, 0
	SUBLW      232
L__interrupt127:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt61
;PI.c,288 :: 		cntUser++;
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
;PI.c,289 :: 		cnt=0;
	CLRF       _cnt+0
	CLRF       _cnt+1
	CLRF       _cnt+2
	CLRF       _cnt+3
;PI.c,290 :: 		}
L_interrupt61:
;PI.c,291 :: 		if(cntUser==tope){
	MOVF       _cntUser+3, 0
	XORWF      _tope+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt128
	MOVF       _cntUser+2, 0
	XORWF      _tope+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt128
	MOVF       _cntUser+1, 0
	XORWF      _tope+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt128
	MOVF       _cntUser+0, 0
	XORWF      _tope+0, 0
L__interrupt128:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt62
;PI.c,292 :: 		RB1_bit=~RB1_bit;
	MOVLW
	XORWF      RB1_bit+0, 1
;PI.c,293 :: 		OPTION_REG = 0x00;
	CLRF       OPTION_REG+0
;PI.c,294 :: 		TMR0 = 0;
	CLRF       TMR0+0
;PI.c,295 :: 		INTCON = 0x00;
	CLRF       INTCON+0
;PI.c,296 :: 		}
L_interrupt62:
;PI.c,297 :: 		}
L_interrupt60:
;PI.c,298 :: 		}
L_end_interrupt:
L__interrupt126:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;PI.c,300 :: 		void main() {
;PI.c,301 :: 		ANSEL  = 255;                     // Configure AN pins as digital
	MOVLW      255
	MOVWF      ANSEL+0
;PI.c,302 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;PI.c,303 :: 		TRISA = 0b00001101;
	MOVLW      13
	MOVWF      TRISA+0
;PI.c,304 :: 		TRISC = 0b10000111;
	MOVLW      135
	MOVWF      TRISC+0
;PI.c,305 :: 		TRISB0_bit = 0;
	BCF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;PI.c,306 :: 		TRISB1_bit = 0;
	BCF        TRISB1_bit+0, BitPos(TRISB1_bit+0)
;PI.c,307 :: 		PORTB = 0;
	CLRF       PORTB+0
;PI.c,308 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;PI.c,309 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main63:
	DECFSZ     R13+0, 1
	GOTO       L_main63
	DECFSZ     R12+0, 1
	GOTO       L_main63
	DECFSZ     R11+0, 1
	GOTO       L_main63
	NOP
;PI.c,310 :: 		UART1_Write_Text("Start");
	MOVLW      ?lstr10_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,311 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;PI.c,312 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PI.c,313 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PI.c,314 :: 		Lcd_Chr(1,1,'P');
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      80
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PI.c,315 :: 		Lcd_Chr_CP('r');
	MOVLW      114
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,316 :: 		Lcd_Chr_CP('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,317 :: 		Lcd_Chr_CP('y');
	MOVLW      121
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,318 :: 		Lcd_Chr_CP('e');
	MOVLW      101
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,319 :: 		Lcd_Chr_CP('c');
	MOVLW      99
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,320 :: 		Lcd_Chr_CP('t');
	MOVLW      116
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,321 :: 		Lcd_Chr_CP('o');
	MOVLW      111
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;PI.c,323 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main64:
	DECFSZ     R13+0, 1
	GOTO       L_main64
	DECFSZ     R12+0, 1
	GOTO       L_main64
	DECFSZ     R11+0, 1
	GOTO       L_main64
	NOP
	NOP
;PI.c,324 :: 		ADC_Init();
	CALL       _ADC_Init+0
;PI.c,325 :: 		EEPROM_Write(0,0);
	CLRF       FARG_EEPROM_Write_Address+0
	CLRF       FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;PI.c,326 :: 		while(1){
L_main65:
;PI.c,328 :: 		if(UPBtn && banderaUp==0){
	BTFSS      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_main69
	MOVF       _banderaUp+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main69
L__main105:
;PI.c,329 :: 		banderaUp = 1;
	MOVLW      1
	MOVWF      _banderaUp+0
;PI.c,330 :: 		opcion = 1;
	MOVLW      1
	MOVWF      _opcion+0
	MOVLW      0
	MOVWF      _opcion+1
;PI.c,332 :: 		Lcd_Out(2,1,"Sample by time");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,333 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main70:
	DECFSZ     R13+0, 1
	GOTO       L_main70
	DECFSZ     R12+0, 1
	GOTO       L_main70
	DECFSZ     R11+0, 1
	GOTO       L_main70
	NOP
	NOP
;PI.c,334 :: 		}
L_main69:
;PI.c,335 :: 		if(!UPBtn && banderaUp==1){
	BTFSC      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_main73
	MOVF       _banderaUp+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main73
L__main104:
;PI.c,336 :: 		banderaUp=0;
	CLRF       _banderaUp+0
;PI.c,337 :: 		}
L_main73:
;PI.c,338 :: 		if(OKBtn && banderaOk==0){
	BTFSS      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L_main76
	MOVF       _banderaOk+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main76
L__main103:
;PI.c,339 :: 		banderaOk = 1;
	MOVLW      1
	MOVWF      _banderaOk+0
;PI.c,340 :: 		}
L_main76:
;PI.c,341 :: 		if(DOWNBtn && banderaDown==0){
	BTFSS      RC2_bit+0, BitPos(RC2_bit+0)
	GOTO       L_main79
	MOVF       _banderaDown+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main79
L__main102:
;PI.c,342 :: 		banderaDown = 1;
	MOVLW      1
	MOVWF      _banderaDown+0
;PI.c,343 :: 		opcion = 2;
	MOVLW      2
	MOVWF      _opcion+0
	MOVLW      0
	MOVWF      _opcion+1
;PI.c,345 :: 		Lcd_Out(2,1,"View samples  ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,346 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main80:
	DECFSZ     R13+0, 1
	GOTO       L_main80
	DECFSZ     R12+0, 1
	GOTO       L_main80
	DECFSZ     R11+0, 1
	GOTO       L_main80
	NOP
	NOP
;PI.c,347 :: 		}
L_main79:
;PI.c,348 :: 		if(!DOWNBtn && banderaDown==1){
	BTFSC      RC2_bit+0, BitPos(RC2_bit+0)
	GOTO       L_main83
	MOVF       _banderaDown+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main83
L__main101:
;PI.c,349 :: 		banderaDown=0;
	CLRF       _banderaDown+0
;PI.c,350 :: 		}
L_main83:
;PI.c,351 :: 		if(banderaOk == 1){
	MOVF       _banderaOk+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main84
;PI.c,352 :: 		if(opcion == 1){
	MOVLW      0
	XORWF      _opcion+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main130
	MOVLW      1
	XORWF      _opcion+0, 0
L__main130:
	BTFSS      STATUS+0, 2
	GOTO       L_main85
;PI.c,353 :: 		cnfTiempoLcd();//Captura tiempo ajustado por el usuario, pasa ese valor a términos de tope
	CALL       _cnfTiempoLcd+0
;PI.c,354 :: 		initTMR0();//Arranca timer, va implícito dentro de la interrupción Muestrear();
	CALL       _initTMR0+0
;PI.c,355 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PI.c,356 :: 		Lcd_Out(1,3,"Muestreando");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,357 :: 		Lcd_Out(2,7,"...");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,358 :: 		while(cntUser<tope){
L_main86:
	MOVF       _tope+3, 0
	SUBWF      _cntUser+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVF       _tope+2, 0
	SUBWF      _cntUser+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVF       _tope+1, 0
	SUBWF      _cntUser+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main131
	MOVF       _tope+0, 0
	SUBWF      _cntUser+0, 0
L__main131:
	BTFSC      STATUS+0, 0
	GOTO       L_main87
;PI.c,359 :: 		if(cnt==999){
	MOVLW      0
	MOVWF      R0+0
	XORWF      _cnt+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVF       R0+0, 0
	XORWF      _cnt+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVLW      3
	XORWF      _cnt+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main132
	MOVF       _cnt+0, 0
	XORLW      231
L__main132:
	BTFSS      STATUS+0, 2
	GOTO       L_main88
;PI.c,360 :: 		muestrear();
	CALL       _Muestrear+0
;PI.c,361 :: 		}
L_main88:
;PI.c,362 :: 		}
	GOTO       L_main86
L_main87:
;PI.c,363 :: 		UART1_Write_Text("\r\n");
	MOVLW      ?lstr15_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,364 :: 		UART1_Write_Text("Voltaje sin dividir:");
	MOVLW      ?lstr16_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,365 :: 		LongToStr(Voltaje,txtLong);
	MOVF       _Voltaje+0, 0
	MOVWF      FARG_LongToStr_input+0
	MOVF       _Voltaje+1, 0
	MOVWF      FARG_LongToStr_input+1
	MOVF       _Voltaje+2, 0
	MOVWF      FARG_LongToStr_input+2
	MOVF       _Voltaje+3, 0
	MOVWF      FARG_LongToStr_input+3
	MOVLW      _txtLong+0
	MOVWF      FARG_LongToStr_output+0
	CALL       _LongToStr+0
;PI.c,366 :: 		UART1_Write_Text(txtLong);
	MOVLW      _txtLong+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,367 :: 		UART1_Write_Text("\r\n");
	MOVLW      ?lstr17_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,368 :: 		Voltaje=Voltaje/tope;
	MOVF       _tope+0, 0
	MOVWF      R4+0
	MOVF       _tope+1, 0
	MOVWF      R4+1
	MOVF       _tope+2, 0
	MOVWF      R4+2
	MOVF       _tope+3, 0
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
;PI.c,369 :: 		UART1_Write_Text("Voltaje dividido:");
	MOVLW      ?lstr18_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,370 :: 		LongToStr(Voltaje,txtLong);
	MOVF       _Voltaje+0, 0
	MOVWF      FARG_LongToStr_input+0
	MOVF       _Voltaje+1, 0
	MOVWF      FARG_LongToStr_input+1
	MOVF       _Voltaje+2, 0
	MOVWF      FARG_LongToStr_input+2
	MOVF       _Voltaje+3, 0
	MOVWF      FARG_LongToStr_input+3
	MOVLW      _txtLong+0
	MOVWF      FARG_LongToStr_output+0
	CALL       _LongToStr+0
;PI.c,371 :: 		UART1_Write_Text(txtLong);
	MOVLW      _txtLong+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,372 :: 		UART1_Write_Text("\r\n");
	MOVLW      ?lstr19_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,373 :: 		UART1_Write_Text("Tope:");
	MOVLW      ?lstr20_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,374 :: 		LongToStr(tope,txtLong);
	MOVF       _tope+0, 0
	MOVWF      FARG_LongToStr_input+0
	MOVF       _tope+1, 0
	MOVWF      FARG_LongToStr_input+1
	MOVF       _tope+2, 0
	MOVWF      FARG_LongToStr_input+2
	MOVF       _tope+3, 0
	MOVWF      FARG_LongToStr_input+3
	MOVLW      _txtLong+0
	MOVWF      FARG_LongToStr_output+0
	CALL       _LongToStr+0
;PI.c,375 :: 		UART1_Write_Text(txtLong);
	MOVLW      _txtLong+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,376 :: 		UART1_Write_Text("\r\n");
	MOVLW      ?lstr21_PI+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
;PI.c,377 :: 		GuardarEEPROM();
	CALL       _GuardarEEPROM+0
;PI.c,378 :: 		Voltaje = 0;
	CLRF       _Voltaje+0
	CLRF       _Voltaje+1
	CLRF       _Voltaje+2
	CLRF       _Voltaje+3
;PI.c,379 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PI.c,380 :: 		Lcd_Out(1,1,"muestreo");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr22_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,381 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main89:
	DECFSZ     R13+0, 1
	GOTO       L_main89
	DECFSZ     R12+0, 1
	GOTO       L_main89
	NOP
	NOP
;PI.c,382 :: 		Lcd_Out(2,1,"completo");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr23_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,383 :: 		}else if(opcion == 2){
	GOTO       L_main90
L_main85:
	MOVLW      0
	XORWF      _opcion+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main133
	MOVLW      2
	XORWF      _opcion+0, 0
L__main133:
	BTFSS      STATUS+0, 2
	GOTO       L_main91
;PI.c,384 :: 		Mostrar();
	CALL       _Mostrar+0
;PI.c,385 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PI.c,386 :: 		Lcd_Out(1,1,"vista");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr24_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,387 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main92:
	DECFSZ     R13+0, 1
	GOTO       L_main92
	DECFSZ     R12+0, 1
	GOTO       L_main92
	NOP
	NOP
;PI.c,388 :: 		Lcd_Out(2,1,"completa");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr25_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,389 :: 		}
L_main91:
L_main90:
;PI.c,390 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main93:
	DECFSZ     R13+0, 1
	GOTO       L_main93
	DECFSZ     R12+0, 1
	GOTO       L_main93
	DECFSZ     R11+0, 1
	GOTO       L_main93
	NOP
	NOP
;PI.c,391 :: 		resetAll();
	CALL       _resetAll+0
;PI.c,392 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PI.c,393 :: 		Lcd_Out(1,1,"Proyecto Integr");                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr26_PI+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PI.c,394 :: 		}
L_main84:
;PI.c,395 :: 		}
	GOTO       L_main65
;PI.c,396 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
