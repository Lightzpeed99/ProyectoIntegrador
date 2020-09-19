
_resetAll:

;ProyectoIntegrador.c,55 :: 		void resetAll(){       //Se resetean todas las variables
;ProyectoIntegrador.c,56 :: 		cntUser = 0;
	CLRF       _cntUser+0
	CLRF       _cntUser+1
	CLRF       _cntUser+2
	CLRF       _cntUser+3
;ProyectoIntegrador.c,57 :: 		banderaUp = 0;
	CLRF       _banderaUp+0
	CLRF       _banderaUp+1
;ProyectoIntegrador.c,58 :: 		banderaOk = 0;
	CLRF       _banderaOk+0
	CLRF       _banderaOk+1
;ProyectoIntegrador.c,59 :: 		banderaDown = 0;
	CLRF       _banderaDown+0
	CLRF       _banderaDown+1
;ProyectoIntegrador.c,60 :: 		opcion = 0;
	CLRF       _opcion+0
	CLRF       _opcion+1
;ProyectoIntegrador.c,61 :: 		i = 0;
	CLRF       _i+0
	CLRF       _i+1
;ProyectoIntegrador.c,62 :: 		tope = 0;
	CLRF       _tope+0
	CLRF       _tope+1
;ProyectoIntegrador.c,63 :: 		valor = 0;
	CLRF       _valor+0
	CLRF       _valor+1
;ProyectoIntegrador.c,64 :: 		cnt =0;
	CLRF       _cnt+0
	CLRF       _cnt+1
	CLRF       _cnt+2
	CLRF       _cnt+3
;ProyectoIntegrador.c,65 :: 		tiempo = 0;
	CLRF       _tiempo+0
	CLRF       _tiempo+1
	CLRF       _tiempo+2
	CLRF       _tiempo+3
;ProyectoIntegrador.c,66 :: 		j = 0;
	CLRF       _j+0
	CLRF       _j+1
;ProyectoIntegrador.c,67 :: 		}
L_end_resetAll:
	RETURN
; end of _resetAll

_Title:

;ProyectoIntegrador.c,69 :: 		void Title(){
;ProyectoIntegrador.c,70 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ProyectoIntegrador.c,71 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ProyectoIntegrador.c,72 :: 		Lcd_Out(1,1,"proyect-muestreo");                 // Write text in first row
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,73 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_Title0:
	DECFSZ     R13+0, 1
	GOTO       L_Title0
	DECFSZ     R12+0, 1
	GOTO       L_Title0
	DECFSZ     R11+0, 1
	GOTO       L_Title0
	NOP
	NOP
;ProyectoIntegrador.c,74 :: 		}
L_end_Title:
	RETURN
; end of _Title

_initTMR0:

;ProyectoIntegrador.c,76 :: 		void initTMR0(){//Arranca el TMR0
;ProyectoIntegrador.c,77 :: 		OPTION_REG         = 0x82;
	MOVLW      130
	MOVWF      OPTION_REG+0
;ProyectoIntegrador.c,78 :: 		TMR0                 = 6;
	MOVLW      6
	MOVWF      TMR0+0
;ProyectoIntegrador.c,79 :: 		INTCON         = 0xA0;
	MOVLW      160
	MOVWF      INTCON+0
;ProyectoIntegrador.c,80 :: 		}
L_end_initTMR0:
	RETURN
; end of _initTMR0

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;ProyectoIntegrador.c,82 :: 		void interrupt(){
;ProyectoIntegrador.c,83 :: 		if (TMR0IF_bit){
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_interrupt1
;ProyectoIntegrador.c,84 :: 		cnt++;
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
;ProyectoIntegrador.c,85 :: 		TMR0IF_bit         = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;ProyectoIntegrador.c,86 :: 		TMR0                 = 6;
	MOVLW      6
	MOVWF      TMR0+0
;ProyectoIntegrador.c,88 :: 		if(cnt>1000){
	MOVF       _cnt+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt110
	MOVF       _cnt+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt110
	MOVF       _cnt+1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt110
	MOVF       _cnt+0, 0
	SUBLW      232
L__interrupt110:
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt2
;ProyectoIntegrador.c,89 :: 		cntUser++;
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
;ProyectoIntegrador.c,90 :: 		RB0_bit=~RB0_bit;
	MOVLW
	XORWF      RB0_bit+0, 1
;ProyectoIntegrador.c,91 :: 		cnt=0;
	CLRF       _cnt+0
	CLRF       _cnt+1
	CLRF       _cnt+2
	CLRF       _cnt+3
;ProyectoIntegrador.c,92 :: 		}
L_interrupt2:
;ProyectoIntegrador.c,93 :: 		if(cntUser==tope){
	MOVLW      0
	BTFSC      _tope+1, 7
	MOVLW      255
	MOVWF      R0+0
	XORWF      _cntUser+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt111
	MOVF       R0+0, 0
	XORWF      _cntUser+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt111
	MOVF       _tope+1, 0
	XORWF      _cntUser+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interrupt111
	MOVF       _cntUser+0, 0
	XORWF      _tope+0, 0
L__interrupt111:
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt3
;ProyectoIntegrador.c,94 :: 		RB1_bit=~RB1_bit;
	MOVLW
	XORWF      RB1_bit+0, 1
;ProyectoIntegrador.c,95 :: 		OPTION_REG         = 0x00;
	CLRF       OPTION_REG+0
;ProyectoIntegrador.c,96 :: 		TMR0                 = 0;
	CLRF       TMR0+0
;ProyectoIntegrador.c,97 :: 		INTCON         = 0x00;
	CLRF       INTCON+0
;ProyectoIntegrador.c,98 :: 		}
L_interrupt3:
;ProyectoIntegrador.c,100 :: 		}
L_interrupt1:
;ProyectoIntegrador.c,102 :: 		}
L_end_interrupt:
L__interrupt109:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_procesarValor:

;ProyectoIntegrador.c,105 :: 		void procesarValor(int opc){
;ProyectoIntegrador.c,106 :: 		espacio = 48+valor;
	MOVF       _valor+0, 0
	ADDLW      48
	MOVWF      R1+0
	MOVLW      0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _valor+1, 0
	MOVWF      R1+1
	MOVF       R1+0, 0
	MOVWF      _espacio+0
	MOVF       R1+1, 0
	MOVWF      _espacio+1
;ProyectoIntegrador.c,107 :: 		if(espacio == 58){//si valor excede el 9, significa que se hará uso del espacio en blanco a la derecha
	MOVLW      0
	XORWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor113
	MOVLW      58
	XORWF      R1+0, 0
L__procesarValor113:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor4
;ProyectoIntegrador.c,109 :: 		valor = 0;
	CLRF       _valor+0
	CLRF       _valor+1
;ProyectoIntegrador.c,110 :: 		if(desp==0){//cuando sucede esto por primera vez, la variable decena trae el valor de -16, pero ahora se
	MOVLW      0
	XORWF      _desp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor114
	MOVLW      0
	XORWF      _desp+0, 0
L__procesarValor114:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor5
;ProyectoIntegrador.c,112 :: 		decena = 0;
	CLRF       _decena+0
	CLRF       _decena+1
;ProyectoIntegrador.c,113 :: 		desp = 1; //desplazamiento se activa, para que más adelante la decena no se vuelva -16
	MOVLW      1
	MOVWF      _desp+0
	MOVLW      0
	MOVWF      _desp+1
;ProyectoIntegrador.c,114 :: 		}
L_procesarValor5:
;ProyectoIntegrador.c,115 :: 		decena++;
	INCF       _decena+0, 1
	BTFSC      STATUS+0, 2
	INCF       _decena+1, 1
;ProyectoIntegrador.c,116 :: 		}
L_procesarValor4:
;ProyectoIntegrador.c,117 :: 		if(espacio == 47){//si se trata de decrementar al valor de 0, este se irá a su límite superior
	MOVLW      0
	XORWF      _espacio+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor115
	MOVLW      47
	XORWF      _espacio+0, 0
L__procesarValor115:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor6
;ProyectoIntegrador.c,118 :: 		valor = 9;
	MOVLW      9
	MOVWF      _valor+0
	MOVLW      0
	MOVWF      _valor+1
;ProyectoIntegrador.c,119 :: 		if(desp == 1){//cuando desplazamiento esté activado, significa que hay decenas cargadas, por lo tanto
	MOVLW      0
	XORWF      _desp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor116
	MOVLW      1
	XORWF      _desp+0, 0
L__procesarValor116:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor7
;ProyectoIntegrador.c,121 :: 		decena--;
	MOVLW      1
	SUBWF      _decena+0, 1
	BTFSS      STATUS+0, 0
	DECF       _decena+1, 1
;ProyectoIntegrador.c,122 :: 		if(decena == 0){//si la decena llega a 0, 'desp'lazamient se vuelve 0, para que adquiera el valor de -16
	MOVLW      0
	XORWF      _decena+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor117
	MOVLW      0
	XORWF      _decena+0, 0
L__procesarValor117:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor8
;ProyectoIntegrador.c,124 :: 		desp = 0;
	CLRF       _desp+0
	CLRF       _desp+1
;ProyectoIntegrador.c,125 :: 		}
L_procesarValor8:
;ProyectoIntegrador.c,126 :: 		}
L_procesarValor7:
;ProyectoIntegrador.c,127 :: 		}
L_procesarValor6:
;ProyectoIntegrador.c,128 :: 		if(desp!=1){//si no se ha hecho un 'desp'lazamiento o más bien ocupado el espacio libre a la izquierda
	MOVLW      0
	XORWF      _desp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor118
	MOVLW      1
	XORWF      _desp+0, 0
L__procesarValor118:
	BTFSC      STATUS+0, 2
	GOTO       L_procesarValor9
;ProyectoIntegrador.c,130 :: 		decena = -16;
	MOVLW      240
	MOVWF      _decena+0
	MOVLW      255
	MOVWF      _decena+1
;ProyectoIntegrador.c,131 :: 		}
L_procesarValor9:
;ProyectoIntegrador.c,133 :: 		switch(opc){
	GOTO       L_procesarValor10
;ProyectoIntegrador.c,134 :: 		case 1://horas
L_procesarValor12:
;ProyectoIntegrador.c,135 :: 		Lcd_Chr(1,13,decena+48);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _decena+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;ProyectoIntegrador.c,136 :: 		Lcd_Chr(1,14,48+valor);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _valor+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;ProyectoIntegrador.c,137 :: 		if(decena == -16){
	MOVLW      255
	XORWF      _decena+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor119
	MOVLW      240
	XORWF      _decena+0, 0
L__procesarValor119:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor13
;ProyectoIntegrador.c,138 :: 		decena = 0;
	CLRF       _decena+0
	CLRF       _decena+1
;ProyectoIntegrador.c,139 :: 		}
L_procesarValor13:
;ProyectoIntegrador.c,140 :: 		horas = decena*10+valor;
	MOVF       _decena+0, 0
	MOVWF      R0+0
	MOVF       _decena+1, 0
	MOVWF      R0+1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       _valor+0, 0
	ADDWF      R0+0, 0
	MOVWF      _horas+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _valor+1, 0
	MOVWF      _horas+1
;ProyectoIntegrador.c,141 :: 		break;
	GOTO       L_procesarValor11
;ProyectoIntegrador.c,142 :: 		case 2://minutos
L_procesarValor14:
;ProyectoIntegrador.c,143 :: 		Lcd_Chr(2,5,decena+48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _decena+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;ProyectoIntegrador.c,144 :: 		Lcd_Chr(2,6,48+valor);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _valor+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;ProyectoIntegrador.c,145 :: 		if(decena == -16){
	MOVLW      255
	XORWF      _decena+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor120
	MOVLW      240
	XORWF      _decena+0, 0
L__procesarValor120:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor15
;ProyectoIntegrador.c,146 :: 		decena = 0;
	CLRF       _decena+0
	CLRF       _decena+1
;ProyectoIntegrador.c,147 :: 		}
L_procesarValor15:
;ProyectoIntegrador.c,148 :: 		minutos = decena*10+valor;
	MOVF       _decena+0, 0
	MOVWF      R0+0
	MOVF       _decena+1, 0
	MOVWF      R0+1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       _valor+0, 0
	ADDWF      R0+0, 0
	MOVWF      _minutos+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _valor+1, 0
	MOVWF      _minutos+1
;ProyectoIntegrador.c,149 :: 		break;
	GOTO       L_procesarValor11
;ProyectoIntegrador.c,150 :: 		case 3://horas
L_procesarValor16:
;ProyectoIntegrador.c,151 :: 		Lcd_Chr(2,13,decena+48);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      48
	ADDWF      _decena+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;ProyectoIntegrador.c,152 :: 		Lcd_Chr(2,14,48+valor);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _valor+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;ProyectoIntegrador.c,153 :: 		if(decena == -16){
	MOVLW      255
	XORWF      _decena+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor121
	MOVLW      240
	XORWF      _decena+0, 0
L__procesarValor121:
	BTFSS      STATUS+0, 2
	GOTO       L_procesarValor17
;ProyectoIntegrador.c,154 :: 		decena = 0;
	CLRF       _decena+0
	CLRF       _decena+1
;ProyectoIntegrador.c,155 :: 		}
L_procesarValor17:
;ProyectoIntegrador.c,156 :: 		segundos = decena*10+valor;
	MOVF       _decena+0, 0
	MOVWF      R0+0
	MOVF       _decena+1, 0
	MOVWF      R0+1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       _valor+0, 0
	ADDWF      R0+0, 0
	MOVWF      _segundos+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _valor+1, 0
	MOVWF      _segundos+1
;ProyectoIntegrador.c,157 :: 		break;
	GOTO       L_procesarValor11
;ProyectoIntegrador.c,158 :: 		}
L_procesarValor10:
	MOVLW      0
	XORWF      FARG_procesarValor_opc+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor122
	MOVLW      1
	XORWF      FARG_procesarValor_opc+0, 0
L__procesarValor122:
	BTFSC      STATUS+0, 2
	GOTO       L_procesarValor12
	MOVLW      0
	XORWF      FARG_procesarValor_opc+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor123
	MOVLW      2
	XORWF      FARG_procesarValor_opc+0, 0
L__procesarValor123:
	BTFSC      STATUS+0, 2
	GOTO       L_procesarValor14
	MOVLW      0
	XORWF      FARG_procesarValor_opc+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__procesarValor124
	MOVLW      3
	XORWF      FARG_procesarValor_opc+0, 0
L__procesarValor124:
	BTFSC      STATUS+0, 2
	GOTO       L_procesarValor16
L_procesarValor11:
;ProyectoIntegrador.c,159 :: 		Delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_procesarValor18:
	DECFSZ     R13+0, 1
	GOTO       L_procesarValor18
	DECFSZ     R12+0, 1
	GOTO       L_procesarValor18
	DECFSZ     R11+0, 1
	GOTO       L_procesarValor18
;ProyectoIntegrador.c,160 :: 		}
L_end_procesarValor:
	RETURN
; end of _procesarValor

_cnfTiempoLcd:

;ProyectoIntegrador.c,163 :: 		void cnfTiempoLcd(){//Captura tiempo a muestrear (TMR0)
;ProyectoIntegrador.c,164 :: 		timing = 1;
	MOVLW      1
	MOVWF      _timing+0
	MOVLW      0
	MOVWF      _timing+1
;ProyectoIntegrador.c,165 :: 		desp = 0;
	CLRF       _desp+0
	CLRF       _desp+1
;ProyectoIntegrador.c,166 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ProyectoIntegrador.c,167 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd19:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd19
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd19
	NOP
	NOP
;ProyectoIntegrador.c,169 :: 		Lcd_Out(1,1,"time: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,170 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd20:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd20
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd20
	NOP
	NOP
;ProyectoIntegrador.c,171 :: 		Lcd_Out(1,9,"hrs[  ]");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,172 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd21:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd21
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd21
	NOP
	NOP
;ProyectoIntegrador.c,173 :: 		Lcd_Out(2,1,"min[  ]");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,174 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd22:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd22
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd22
	NOP
	NOP
;ProyectoIntegrador.c,175 :: 		Lcd_Out(2,9,"seg[  ]");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      9
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,176 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd23:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd23
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd23
	NOP
	NOP
;ProyectoIntegrador.c,177 :: 		valor = 0;
	CLRF       _valor+0
	CLRF       _valor+1
;ProyectoIntegrador.c,178 :: 		while(timing != 4){//timing sirve para saber en qué unidad de tiempo se está ajustando el parámetro
L_cnfTiempoLcd24:
	MOVLW      0
	XORWF      _timing+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd126
	MOVLW      4
	XORWF      _timing+0, 0
L__cnfTiempoLcd126:
	BTFSC      STATUS+0, 2
	GOTO       L_cnfTiempoLcd25
;ProyectoIntegrador.c,179 :: 		if(UPBtn && banderaUp==0){//incrementa unidades de tiempo con el botón de UP
	BTFSS      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_cnfTiempoLcd28
	MOVLW      0
	XORWF      _banderaUp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd127
	MOVLW      0
	XORWF      _banderaUp+0, 0
L__cnfTiempoLcd127:
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd28
L__cnfTiempoLcd98:
;ProyectoIntegrador.c,180 :: 		banderaUp = 1;
	MOVLW      1
	MOVWF      _banderaUp+0
	MOVLW      0
	MOVWF      _banderaUp+1
;ProyectoIntegrador.c,181 :: 		valor++;
	INCF       _valor+0, 1
	BTFSC      STATUS+0, 2
	INCF       _valor+1, 1
;ProyectoIntegrador.c,182 :: 		procesarValor(timing);//dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
	MOVF       _timing+0, 0
	MOVWF      FARG_procesarValor_opc+0
	MOVF       _timing+1, 0
	MOVWF      FARG_procesarValor_opc+1
	CALL       _procesarValor+0
;ProyectoIntegrador.c,183 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd29:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd29
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd29
	NOP
	NOP
;ProyectoIntegrador.c,184 :: 		}
L_cnfTiempoLcd28:
;ProyectoIntegrador.c,185 :: 		if(!UPBtn && banderaUp==1){
	BTFSC      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_cnfTiempoLcd32
	MOVLW      0
	XORWF      _banderaUp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd128
	MOVLW      1
	XORWF      _banderaUp+0, 0
L__cnfTiempoLcd128:
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd32
L__cnfTiempoLcd97:
;ProyectoIntegrador.c,186 :: 		banderaUp=0;
	CLRF       _banderaUp+0
	CLRF       _banderaUp+1
;ProyectoIntegrador.c,187 :: 		}
L_cnfTiempoLcd32:
;ProyectoIntegrador.c,188 :: 		if(OKBtn && banderaOk==0){//Se acepta el valor cargado en las unidades de tiempo, se incrementa al siguiente
	BTFSS      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L_cnfTiempoLcd35
	MOVLW      0
	XORWF      _banderaOk+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd129
	MOVLW      0
	XORWF      _banderaOk+0, 0
L__cnfTiempoLcd129:
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd35
L__cnfTiempoLcd96:
;ProyectoIntegrador.c,190 :: 		timing++;
	INCF       _timing+0, 1
	BTFSC      STATUS+0, 2
	INCF       _timing+1, 1
;ProyectoIntegrador.c,191 :: 		banderaOk = 1;
	MOVLW      1
	MOVWF      _banderaOk+0
	MOVLW      0
	MOVWF      _banderaOk+1
;ProyectoIntegrador.c,192 :: 		decena = 0;
	CLRF       _decena+0
	CLRF       _decena+1
;ProyectoIntegrador.c,193 :: 		valor = 0;
	CLRF       _valor+0
	CLRF       _valor+1
;ProyectoIntegrador.c,194 :: 		desp = 0;
	CLRF       _desp+0
	CLRF       _desp+1
;ProyectoIntegrador.c,195 :: 		}
L_cnfTiempoLcd35:
;ProyectoIntegrador.c,196 :: 		if(!OKBtn && banderaOk==1){
	BTFSC      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L_cnfTiempoLcd38
	MOVLW      0
	XORWF      _banderaOk+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd130
	MOVLW      1
	XORWF      _banderaOk+0, 0
L__cnfTiempoLcd130:
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd38
L__cnfTiempoLcd95:
;ProyectoIntegrador.c,197 :: 		banderaOk=0;
	CLRF       _banderaOk+0
	CLRF       _banderaOk+1
;ProyectoIntegrador.c,198 :: 		}
L_cnfTiempoLcd38:
;ProyectoIntegrador.c,199 :: 		if(DOWNBtn && banderaDown==0){//Decrementa unidades de tiempo con el botón Down
	BTFSS      RC2_bit+0, BitPos(RC2_bit+0)
	GOTO       L_cnfTiempoLcd41
	MOVLW      0
	XORWF      _banderaDown+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd131
	MOVLW      0
	XORWF      _banderaDown+0, 0
L__cnfTiempoLcd131:
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd41
L__cnfTiempoLcd94:
;ProyectoIntegrador.c,200 :: 		banderaDown = 1;
	MOVLW      1
	MOVWF      _banderaDown+0
	MOVLW      0
	MOVWF      _banderaDown+1
;ProyectoIntegrador.c,201 :: 		valor--;
	MOVLW      1
	SUBWF      _valor+0, 1
	BTFSS      STATUS+0, 0
	DECF       _valor+1, 1
;ProyectoIntegrador.c,202 :: 		procesarValor(timing);//dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
	MOVF       _timing+0, 0
	MOVWF      FARG_procesarValor_opc+0
	MOVF       _timing+1, 0
	MOVWF      FARG_procesarValor_opc+1
	CALL       _procesarValor+0
;ProyectoIntegrador.c,203 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_cnfTiempoLcd42:
	DECFSZ     R13+0, 1
	GOTO       L_cnfTiempoLcd42
	DECFSZ     R12+0, 1
	GOTO       L_cnfTiempoLcd42
	NOP
	NOP
;ProyectoIntegrador.c,204 :: 		}
L_cnfTiempoLcd41:
;ProyectoIntegrador.c,205 :: 		if(!DOWNBtn && banderaDown==1){
	BTFSC      RC2_bit+0, BitPos(RC2_bit+0)
	GOTO       L_cnfTiempoLcd45
	MOVLW      0
	XORWF      _banderaDown+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__cnfTiempoLcd132
	MOVLW      1
	XORWF      _banderaDown+0, 0
L__cnfTiempoLcd132:
	BTFSS      STATUS+0, 2
	GOTO       L_cnfTiempoLcd45
L__cnfTiempoLcd93:
;ProyectoIntegrador.c,206 :: 		banderaDown=0;
	CLRF       _banderaDown+0
	CLRF       _banderaDown+1
;ProyectoIntegrador.c,207 :: 		}
L_cnfTiempoLcd45:
;ProyectoIntegrador.c,208 :: 		}
	GOTO       L_cnfTiempoLcd24
L_cnfTiempoLcd25:
;ProyectoIntegrador.c,209 :: 		tope = horas*360+minutos*60+segundos;
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
;ProyectoIntegrador.c,210 :: 		}
L_end_cnfTiempoLcd:
	RETURN
; end of _cnfTiempoLcd

_muestrear:

;ProyectoIntegrador.c,212 :: 		void muestrear(){
;ProyectoIntegrador.c,213 :: 		RB0_bit=~RB0_bit;
	MOVLW
	XORWF      RB0_bit+0, 1
;ProyectoIntegrador.c,214 :: 		}
L_end_muestrear:
	RETURN
; end of _muestrear

_Mostrar:

;ProyectoIntegrador.c,216 :: 		void Mostrar(){//Dentro del while, la i representa el índice de la memoria eeprom que se irá incrementando cada que
;ProyectoIntegrador.c,217 :: 		cmpTope = 1;
	MOVLW      1
	MOVWF      _cmpTope+0
	MOVLW      0
	MOVWF      _cmpTope+1
;ProyectoIntegrador.c,218 :: 		cmpData = 1;
	MOVLW      1
	MOVWF      _cmpData+0
	MOVLW      0
	MOVWF      _cmpData+1
;ProyectoIntegrador.c,219 :: 		recorre = 1;
	MOVLW      1
	MOVWF      _recorre+0
	MOVLW      0
	MOVWF      _recorre+1
;ProyectoIntegrador.c,220 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ProyectoIntegrador.c,221 :: 		while(cmpTope <= 4){
L_Mostrar46:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _cmpTope+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar135
	MOVF       _cmpTope+0, 0
	SUBLW      4
L__Mostrar135:
	BTFSS      STATUS+0, 0
	GOTO       L_Mostrar47
;ProyectoIntegrador.c,222 :: 		while(cmpData <= 5){
L_Mostrar48:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      _cmpData+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar136
	MOVF       _cmpData+0, 0
	SUBLW      5
L__Mostrar136:
	BTFSS      STATUS+0, 0
	GOTO       L_Mostrar49
;ProyectoIntegrador.c,223 :: 		if(cmpData==2){
	MOVLW      0
	XORWF      _cmpData+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Mostrar137
	MOVLW      2
	XORWF      _cmpData+0, 0
L__Mostrar137:
	BTFSS      STATUS+0, 2
	GOTO       L_Mostrar50
;ProyectoIntegrador.c,224 :: 		Lcd_Out(2,4+cmpData,".");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVF       _cmpData+0, 0
	ADDLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,225 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_Mostrar51:
	DECFSZ     R13+0, 1
	GOTO       L_Mostrar51
	DECFSZ     R12+0, 1
	GOTO       L_Mostrar51
	NOP
	NOP
;ProyectoIntegrador.c,226 :: 		}else{
	GOTO       L_Mostrar52
L_Mostrar50:
;ProyectoIntegrador.c,227 :: 		Lcd_Chr(2,4+cmpData,48+EEPROM_Read(recorre));
	MOVF       _recorre+0, 0
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _cmpData+0, 0
	ADDLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	CALL       _Lcd_Chr+0
;ProyectoIntegrador.c,228 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_Mostrar53:
	DECFSZ     R13+0, 1
	GOTO       L_Mostrar53
	DECFSZ     R12+0, 1
	GOTO       L_Mostrar53
	DECFSZ     R11+0, 1
	GOTO       L_Mostrar53
	NOP
;ProyectoIntegrador.c,229 :: 		recorre++;
	INCF       _recorre+0, 1
	BTFSC      STATUS+0, 2
	INCF       _recorre+1, 1
;ProyectoIntegrador.c,230 :: 		}
L_Mostrar52:
;ProyectoIntegrador.c,232 :: 		cmpData++;
	INCF       _cmpData+0, 1
	BTFSC      STATUS+0, 2
	INCF       _cmpData+1, 1
;ProyectoIntegrador.c,233 :: 		}
	GOTO       L_Mostrar48
L_Mostrar49:
;ProyectoIntegrador.c,234 :: 		Lcd_Out(2,10,"V");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      10
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,235 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_Mostrar54:
	DECFSZ     R13+0, 1
	GOTO       L_Mostrar54
	DECFSZ     R12+0, 1
	GOTO       L_Mostrar54
	DECFSZ     R11+0, 1
	GOTO       L_Mostrar54
	NOP
	NOP
;ProyectoIntegrador.c,236 :: 		cmpTope++;
	INCF       _cmpTope+0, 1
	BTFSC      STATUS+0, 2
	INCF       _cmpTope+1, 1
;ProyectoIntegrador.c,237 :: 		}
	GOTO       L_Mostrar46
L_Mostrar47:
;ProyectoIntegrador.c,238 :: 		}
L_end_Mostrar:
	RETURN
; end of _Mostrar

_main:

;ProyectoIntegrador.c,242 :: 		void main() {
;ProyectoIntegrador.c,243 :: 		ANSEL  = 255;                     // Configure AN pins as digital
	MOVLW      255
	MOVWF      ANSEL+0
;ProyectoIntegrador.c,244 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;ProyectoIntegrador.c,245 :: 		TRISA = 0b00001101;
	MOVLW      13
	MOVWF      TRISA+0
;ProyectoIntegrador.c,246 :: 		TRISC = 0b10000111;
	MOVLW      135
	MOVWF      TRISC+0
;ProyectoIntegrador.c,247 :: 		TRISD = 0x00;
	CLRF       TRISD+0
;ProyectoIntegrador.c,248 :: 		PORTD = 0;
	CLRF       PORTD+0
;ProyectoIntegrador.c,249 :: 		TRISB0_bit=0;
	BCF        TRISB0_bit+0, BitPos(TRISB0_bit+0)
;ProyectoIntegrador.c,250 :: 		TRISB1_bit=0;
	BCF        TRISB1_bit+0, BitPos(TRISB1_bit+0)
;ProyectoIntegrador.c,251 :: 		PORTB = 0;
	CLRF       PORTB+0
;ProyectoIntegrador.c,252 :: 		UART1_Init(9600);               // Initialize UART module at 9600 bps
	MOVLW      51
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
;ProyectoIntegrador.c,253 :: 		Delay_ms(100);                  // Wait for UART module to stabilize
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main55:
	DECFSZ     R13+0, 1
	GOTO       L_main55
	DECFSZ     R12+0, 1
	GOTO       L_main55
	DECFSZ     R11+0, 1
	GOTO       L_main55
	NOP
;ProyectoIntegrador.c,255 :: 		Lcd_Init();                        // Initialize LCD
	CALL       _Lcd_Init+0
;ProyectoIntegrador.c,256 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ProyectoIntegrador.c,260 :: 		Title();
	CALL       _Title+0
;ProyectoIntegrador.c,261 :: 		ADC_Init();
	CALL       _ADC_Init+0
;ProyectoIntegrador.c,264 :: 		while(1){
L_main56:
;ProyectoIntegrador.c,265 :: 		if(UPBtn && banderaUp==0){ //muestra opcion muestrear en el manu
	BTFSS      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_main60
	MOVLW      0
	XORWF      _banderaUp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main139
	MOVLW      0
	XORWF      _banderaUp+0, 0
L__main139:
	BTFSS      STATUS+0, 2
	GOTO       L_main60
L__main104:
;ProyectoIntegrador.c,266 :: 		banderaUp = 1;
	MOVLW      1
	MOVWF      _banderaUp+0
	MOVLW      0
	MOVWF      _banderaUp+1
;ProyectoIntegrador.c,267 :: 		opcion = 1;
	MOVLW      1
	MOVWF      _opcion+0
	MOVLW      0
	MOVWF      _opcion+1
;ProyectoIntegrador.c,268 :: 		Lcd_Out(2,1,"muestrear");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,269 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main61:
	DECFSZ     R13+0, 1
	GOTO       L_main61
	DECFSZ     R12+0, 1
	GOTO       L_main61
	DECFSZ     R11+0, 1
	GOTO       L_main61
	NOP
	NOP
;ProyectoIntegrador.c,271 :: 		}
L_main60:
;ProyectoIntegrador.c,272 :: 		if(!UPBtn && banderaUp==1){
	BTFSC      RC0_bit+0, BitPos(RC0_bit+0)
	GOTO       L_main64
	MOVLW      0
	XORWF      _banderaUp+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main140
	MOVLW      1
	XORWF      _banderaUp+0, 0
L__main140:
	BTFSS      STATUS+0, 2
	GOTO       L_main64
L__main103:
;ProyectoIntegrador.c,273 :: 		banderaUp=0;
	CLRF       _banderaUp+0
	CLRF       _banderaUp+1
;ProyectoIntegrador.c,274 :: 		}
L_main64:
;ProyectoIntegrador.c,275 :: 		if(OKBtn && banderaOk==0){ //cuando alguna opcion del menu se selecciona
	BTFSS      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L_main67
	MOVLW      0
	XORWF      _banderaOk+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main141
	MOVLW      0
	XORWF      _banderaOk+0, 0
L__main141:
	BTFSS      STATUS+0, 2
	GOTO       L_main67
L__main102:
;ProyectoIntegrador.c,276 :: 		banderaOk = 1;
	MOVLW      1
	MOVWF      _banderaOk+0
	MOVLW      0
	MOVWF      _banderaOk+1
;ProyectoIntegrador.c,277 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ProyectoIntegrador.c,278 :: 		Delay_ms(20);
	MOVLW      52
	MOVWF      R12+0
	MOVLW      241
	MOVWF      R13+0
L_main68:
	DECFSZ     R13+0, 1
	GOTO       L_main68
	DECFSZ     R12+0, 1
	GOTO       L_main68
	NOP
	NOP
;ProyectoIntegrador.c,279 :: 		}
L_main67:
;ProyectoIntegrador.c,280 :: 		if(!OKBtn && banderaOk==1){
	BTFSC      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L_main71
	MOVLW      0
	XORWF      _banderaOk+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main142
	MOVLW      1
	XORWF      _banderaOk+0, 0
L__main142:
	BTFSS      STATUS+0, 2
	GOTO       L_main71
L__main101:
;ProyectoIntegrador.c,281 :: 		banderaOk=1;
	MOVLW      1
	MOVWF      _banderaOk+0
	MOVLW      0
	MOVWF      _banderaOk+1
;ProyectoIntegrador.c,282 :: 		}
L_main71:
;ProyectoIntegrador.c,283 :: 		if(DOWNBtn && banderaDown==0){
	BTFSS      RC2_bit+0, BitPos(RC2_bit+0)
	GOTO       L_main74
	MOVLW      0
	XORWF      _banderaDown+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main143
	MOVLW      0
	XORWF      _banderaDown+0, 0
L__main143:
	BTFSS      STATUS+0, 2
	GOTO       L_main74
L__main100:
;ProyectoIntegrador.c,284 :: 		banderaDown = 1;
	MOVLW      1
	MOVWF      _banderaDown+0
	MOVLW      0
	MOVWF      _banderaDown+1
;ProyectoIntegrador.c,285 :: 		opcion = 2;
	MOVLW      2
	MOVWF      _opcion+0
	MOVLW      0
	MOVWF      _opcion+1
;ProyectoIntegrador.c,287 :: 		Lcd_Out(2,1,"visualizar");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,288 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main75:
	DECFSZ     R13+0, 1
	GOTO       L_main75
	DECFSZ     R12+0, 1
	GOTO       L_main75
	DECFSZ     R11+0, 1
	GOTO       L_main75
	NOP
	NOP
;ProyectoIntegrador.c,289 :: 		}
L_main74:
;ProyectoIntegrador.c,290 :: 		if(!DOWNBtn && banderaDown==1){ // opcion de Mostrar muestreos guardados
	BTFSC      RC2_bit+0, BitPos(RC2_bit+0)
	GOTO       L_main78
	MOVLW      0
	XORWF      _banderaDown+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main144
	MOVLW      1
	XORWF      _banderaDown+0, 0
L__main144:
	BTFSS      STATUS+0, 2
	GOTO       L_main78
L__main99:
;ProyectoIntegrador.c,291 :: 		banderaDown=0;
	CLRF       _banderaDown+0
	CLRF       _banderaDown+1
;ProyectoIntegrador.c,292 :: 		}
L_main78:
;ProyectoIntegrador.c,295 :: 		if(banderaOk == 1){
	MOVLW      0
	XORWF      _banderaOk+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main145
	MOVLW      1
	XORWF      _banderaOk+0, 0
L__main145:
	BTFSS      STATUS+0, 2
	GOTO       L_main79
;ProyectoIntegrador.c,296 :: 		if(opcion == 1){//si la opcion elegida fue Muestrear un determinado tiempo
	MOVLW      0
	XORWF      _opcion+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main146
	MOVLW      1
	XORWF      _opcion+0, 0
L__main146:
	BTFSS      STATUS+0, 2
	GOTO       L_main80
;ProyectoIntegrador.c,297 :: 		cnfTiempoLcd();
	CALL       _cnfTiempoLcd+0
;ProyectoIntegrador.c,299 :: 		initTMR0();//Arranca timer
	CALL       _initTMR0+0
;ProyectoIntegrador.c,302 :: 		ultimo = 5;
	MOVLW      5
	MOVWF      _ultimo+0
	MOVLW      0
	MOVWF      _ultimo+1
;ProyectoIntegrador.c,303 :: 		while(cntUser < tope){
L_main81:
	MOVLW      0
	BTFSC      _tope+1, 7
	MOVLW      255
	SUBWF      _cntUser+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main147
	MOVLW      0
	BTFSC      _tope+1, 7
	MOVLW      255
	SUBWF      _cntUser+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main147
	MOVF       _tope+1, 0
	SUBWF      _cntUser+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main147
	MOVF       _tope+0, 0
	SUBWF      _cntUser+0, 0
L__main147:
	BTFSC      STATUS+0, 0
	GOTO       L_main82
;ProyectoIntegrador.c,304 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ProyectoIntegrador.c,305 :: 		Lcd_Out(1,1,"trabajando");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr10_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,306 :: 		Delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main83:
	DECFSZ     R13+0, 1
	GOTO       L_main83
	DECFSZ     R12+0, 1
	GOTO       L_main83
	DECFSZ     R11+0, 1
	GOTO       L_main83
;ProyectoIntegrador.c,307 :: 		}
	GOTO       L_main81
L_main82:
;ProyectoIntegrador.c,310 :: 		lectura=1;
	MOVLW      1
	MOVWF      _lectura+0
;ProyectoIntegrador.c,311 :: 		while(lectura<=16){
L_main84:
	MOVLW      128
	XORLW      16
	MOVWF      R0+0
	MOVLW      128
	XORWF      _lectura+0, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main85
;ProyectoIntegrador.c,312 :: 		EEPROM_Write(0x00+lectura,lectura);
	MOVF       _lectura+0, 0
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _lectura+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;ProyectoIntegrador.c,313 :: 		lectura++;
	INCF       _lectura+0, 1
;ProyectoIntegrador.c,314 :: 		}
	GOTO       L_main84
L_main85:
;ProyectoIntegrador.c,316 :: 		EEPROM_Write(0x00,0x00+4);
	CLRF       FARG_EEPROM_Write_Address+0
	MOVLW      4
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;ProyectoIntegrador.c,320 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ProyectoIntegrador.c,321 :: 		Delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main86:
	DECFSZ     R13+0, 1
	GOTO       L_main86
	DECFSZ     R12+0, 1
	GOTO       L_main86
	DECFSZ     R11+0, 1
	GOTO       L_main86
;ProyectoIntegrador.c,322 :: 		Lcd_Out(1,1,"muestreo");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr11_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,323 :: 		Delay_ms(50);
	MOVLW      130
	MOVWF      R12+0
	MOVLW      221
	MOVWF      R13+0
L_main87:
	DECFSZ     R13+0, 1
	GOTO       L_main87
	DECFSZ     R12+0, 1
	GOTO       L_main87
	NOP
	NOP
;ProyectoIntegrador.c,324 :: 		Lcd_Out(2,1,"listo");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr12_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,325 :: 		Delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main88:
	DECFSZ     R13+0, 1
	GOTO       L_main88
	DECFSZ     R12+0, 1
	GOTO       L_main88
	DECFSZ     R11+0, 1
	GOTO       L_main88
	NOP
	NOP
;ProyectoIntegrador.c,326 :: 		RB0_bit=0;
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
;ProyectoIntegrador.c,327 :: 		RB1_bit=0;
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
;ProyectoIntegrador.c,330 :: 		}else if(opcion == 2){// si la opcion elegida es mostrar los muestreos guardados
	GOTO       L_main89
L_main80:
	MOVLW      0
	XORWF      _opcion+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main148
	MOVLW      2
	XORWF      _opcion+0, 0
L__main148:
	BTFSS      STATUS+0, 2
	GOTO       L_main90
;ProyectoIntegrador.c,331 :: 		Mostrar();
	CALL       _Mostrar+0
;ProyectoIntegrador.c,332 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;ProyectoIntegrador.c,333 :: 		Delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main91:
	DECFSZ     R13+0, 1
	GOTO       L_main91
	DECFSZ     R12+0, 1
	GOTO       L_main91
	DECFSZ     R11+0, 1
	GOTO       L_main91
;ProyectoIntegrador.c,334 :: 		Lcd_Out(1,1,"vista");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr13_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,335 :: 		Delay_ms(50);
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
;ProyectoIntegrador.c,336 :: 		Lcd_Out(2,1,"completa");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr14_ProyectoIntegrador+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;ProyectoIntegrador.c,337 :: 		}
L_main90:
L_main89:
;ProyectoIntegrador.c,338 :: 		resetAll();
	CALL       _resetAll+0
;ProyectoIntegrador.c,339 :: 		Title();
	CALL       _Title+0
;ProyectoIntegrador.c,340 :: 		}
L_main79:
;ProyectoIntegrador.c,341 :: 		}
	GOTO       L_main56
;ProyectoIntegrador.c,342 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
