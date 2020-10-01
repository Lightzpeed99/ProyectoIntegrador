// Archivos hexadecimales
#include <16F887.h>
#include <stdint.h>
#device PASS_STRINGS = IN_RAM

#fuses HS         // High Speed Oscillator
#fuses NOWDT      // Reset de perro guardi�n desactivado 
#fuses NOPUT      // No Power Up Timer
#fuses MCLR       // Masterclear activado (a VDD con res10k) 
#fuses NOBROWNOUT // Reset de bajo voltaje desacttivado 
#fuses NOIESO     // Cambio entre oscilador interno y externo desactivado 
#fuses NOFCMEN    // Monitor de reloj a prueba de fallos desactivado 
#fuses NOLVP      // No Bajo voltaje de programaci�n en B3(PIC16)
#fuses NODEBUG    // No modo Debug para ICD (In Circuit Debug)
#define sAN0 1    // | A0
#use delay(clock = 8MHz)                         // Frecuencia final de reloj
#include <stdlib.h>
#use rs232(baud = 9600, xmit= PIN_C6, rcv=PIN_C7,stream=receptor) // Inicializa comunicaci�n UART, para Debugguear

#include <STRING.h>


#BYTE RCREG = 0xF1A          // RECEIVE REG
#BIT RCIF_bit = 0xF0C.5      // PIR1.RCIF RECEIVE FLAG
#BIT CREN_bit = 0xF18.4      // RCSTA.CREN CONTINOUS RECEPTION ENABLED
#BYTE INTCON = 0xF8B         // INTERRUPTION CONTROL
#BIT GIE_bit = 0xF8B.7       // INTCON.GIE GLOBAL INTERRUPTIONS ENABLED
#BIT RCIE_bit = 0xF8C.5      // PIE1.RCIE RECEPTION CONTINOUS
#BIT PEIE_bit = 0xF8B.6      // INTCON.PEIE PERIPHERIAL INTERRUPTIONS EN
//PORTS
#BYTE PORTA =  0xF05
#BYTE PORTB =  0xF06
#BYTE PORTC =  0xF07
#BYTE PORTD =  0xF08
#BYTE PORTE =  0xF09
//TYPE PORTS
#BYTE TRISA =  0xF85
#BYTE TRISB =  0xF86
#BYTE TRISC =  0xF87
#BYTE TRISD =  0xF88
#BYTE TRISE =  0xF89

signed char trama[30];//vector para guarda la trama Recibida
signed char envia[30];
char cuenta = 0;//contador de datos que llegan
char banderarecepcion = 0;//bandera de que la nextion mando info
char dato = 0;
int i = 0;
char flag_rx = 0;

void resetAll(){       //Se resetean todas las variables
    cuenta = 0;//contador de datos que llegan
    banderarecepcion = 0;//bandera de que la nextion mando info
    dato = 0;
    memset(trama,0,30);
    memset(envia,0,30);
}

//BANDERA DE INTERRUPCION PARA RETENER DATOS
//void interrupcion() iv 0x0004 ics ICS_AUTO {//iv Interruption Vector
//void interrupcion() iv 0x0008 ics ICS_AUTO{
#int_EXT
void interrupt(){
  if (RCIF_bit == 1){//analiza si hay dato serial
    //PORTB = 255;
    dato=RCREG;  //lee el dato
    trama[cuenta] = dato;   //lo almacena en el vector
    if ((cuenta > 3) && ((unsigned char)trama[cuenta] == 0xff) && ((unsigned char)trama[cuenta-1] == 0xff) && ((unsigned char)trama[cuenta-2] == 0xff)){
      banderarecepcion = 1;//activa la bandera de que llego trama comple y ista para procesar
      CREN_bit = 0;  //DESHABILITA LA RECEPCION CONTINUA PARA LIMPIAR BUFFER    Y NO RECIBIR MIENTRA VA ANALIZAR
      GIE_bit=0;  //deshabilita las interrpciones para poder procesar la trama
    }
    cuenta++;//incrementa contador o puntero del vectro de recibido
    //si es mayor que 30 debe limpiar la bandera y reiniciar el contador llego al maximo
    if (cuenta >= 30){
      banderarecepcion = 0;
      cuenta = 0;
    }
    RCIF_bit=0;//limpia el bit de interrupcion
  }
}

void mover_Graph(){
  //for(i = 0; i<255; i++){
  // 657 -D 10 bits
  //  255 -D 8 bits
  //VoltInt = 0;
  //lect = ADC_Read(0);
  i = read_adc();
  delay_ms(1);
  //VoltInt = (lect*255)/1023;//10 bits A 8 bits
  printf("add 8,0,%u\xFF\xFF\xFF",i);
  //}
}

//TRATAMIENTO DE SE�AL
void procesa_rx(){
  //if (banderarecepcion == 1){//si la bandera de la trama esta activa
    //RB7_bit = ~RB7_bit;
    //BITS DE RESIDUO POTENCIOMETRO
    mover_Graph();
    if (strstr(trama,"a")){
      PORTB = 0B10101010;
    }
    if(strstr(trama,"bueno")){
      PORTB = 0B11110000;
    }
    memset(trama,0,30);
    cuenta = 0;  //limpia el contador
    banderarecepcion = 0; //limpia la bandera
    //PIR1.F5 = 0; //limpia la bandera de interrpcion
    RCIF_bit=0; //limpia la bandera de interrpcion
    //PORTB = 0;
    CREN_bit = 1;
    //INTCON.F7 = 1;
    GIE_bit=1; //habilita interrpcion
  //}
}

void main(){
  //ANSEL = 255;                           //Pines analogicos del puerto A, B desactivados
  //ANSELH = 0;                          //Pines analogicos del puerto E desactivados
  //ADCON1 = 0;
  TRISA = 0b00001101;
  TRISB = 0;
  TRISC = 0b10000000;//entrada pin RX  salida pin TX
  TRISD = 0;
  TRISE = 0;
  PORTA = 0;
  PORTD = 0;
  PORTC = 0;
  PORTB = 0;
  PORTE = 0;
  setup_adc_ports(sAN0);
  setup_adc(adc_clock_internal);
  set_adc_channel(0);
  resetAll();
  enable_interrupts(GLOBAL); //Habilita interrupciones
  /*enable_interrupts(int_EXT);  //Habilita interrupcion externa
  //habilita int serial
  RCIF_bit=0;
  RCIE_bit=1;
  PEIE_bit = 1;
  GIE_bit=1;*/
  Delay_ms(100);
  PORTB = 255;
  Delay_ms(1000);
  PORTB = 0;
  while(1){
    //flag_rx=fgetc(receptor);
    //gets(trama);
    if(banderarecepcion){
      mover_Graph();
      banderarecepcion=0;
    }
  }
}
