unsigned char trama[30];//vector para guarda la trama Recibida
char envia[30];
char valor[2];
char cuenta = 0;//contador de datos que llegan
char flag_rx = 0;//bandera de que la nextion mando info
char dato = 0;
int i = 0;

/*
void enviarDato(int valor){
  sprinti(envia,"add s0,0,%d",valor);
  UART1_Write_Text(envia);
  manda_serial_const("\xFF\xFF\xFF");
}
*/
void manda_serial_const(const char *info){
  while(*info){
    UART1_Write(*info++);
  }
}

//BANDERA DE INTERRUPCION PARA RETENER DATOS
//void interrupcion() iv 0x0004 ics ICS_AUTO {//iv Interruption Vector
void interrupt(){
  if (RCIF_bit == 1){//analiza si hay dato serial
    dato=RCREG;  //lee el dato
    trama[cuenta] = dato;   //lo almacena en el vector
    if ((cuenta > 3) && (trama[cuenta] == 0xff) && (trama[cuenta-1] == 0xff) && (trama[cuenta-2] == 0xff)){
      flag_rx = 1;//activa la bandera de que llego trama comple y ista para procesar
      CREN_bit = 0;  //DESHABILITA LA RECEPCION CONTINU PARA LIMPIAR BUFFER    Y NO RECIBIR MIENTRA VA A NALIZAR
      INTCON.F7 = 0;  //deshabilita las interrpciones para poder procesar la trama
    }
    cuenta++;//incrementa contador o puntero del vectro de recibido
    //si es mayor que 30 debe limpiar la bandera y reiniciar el contador llego al maximo
    if (cuenta == 30){
      flag_rx = 0;
      cuenta = 0;
    }
    PIR1.F5 = 0; //limpia el bit de interrupcion
  }
}

//TRATAMIENTO DE SEÑAL
void procesa_Rx(){
  if (flag_rx==1){//si la bandera de la trama esta activa
    //BITS DE RESIDUO POTENCIOMETRO
    if ( strstr(trama,"DAC=")){

    }
    memset(trama,0,30);
    cuenta=0;  //limpia el contador
    flag_rx=0; //limpia la bandera
    PIR1.F5=0; //limpia la bandera de interrpcion
    CREN_bit=1;
    INTCON.F7=1;
  }
}
void mover_Graph(){
  for(i = 0; i<255; i++){
    sprinti(envia,"add 1,0,%d",i);
    UART1_Write_Text(envia);
    manda_serial_const("\xFF\xFF\xFF");
  }
}

void main() {
  ANSEL=0;                           //Pines analogicos del puerto A, B desactivados
  ANSELH=0;                          //Pines analogicos del puerto E desactivados

  PORTA=0;
  PORTD=0;
  PORTC=0;
  PORTB=0;
  PORTE=0;
  TRISA=0;
  TRISB=0;
  TRISD=0;
  TRISE=0;
  TRISC6_bit=0; //salida pin TX
  TRISC7_bit=1; //entrada pin RX
  cuenta=0;
  UART1_Init(9600);
  memset(envia,0,30);
  //habilita int serial
  PIR1.F5=0;
  PIE1.F5=1;
  INTCON.F6=1;
  INTCON.F7=1;
  while(1){
    //procesa_Rx();
    mover_Graph();
    if(flag_rx){
      procesa_Rx();
      Delay_ms(1000);
    }
  }
}