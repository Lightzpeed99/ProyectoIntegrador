sbit UPBtn at RC0_bit;
sbit OKBtn at RC1_bit;
sbit DOWNBtn at RC2_bit;

signed char trama[30];//vector para guarda la trama Recibida
char envia[30];
char valor[2];
char cuenta = 0;//contador de datos que llegan
char flag_rx = 0;//bandera de que la nextion mando info
char dato = 0;
int i = 0;
int flag_mv = 0;
int flag_end = 0;
int der = 0;
int a = 0;
//////////////////////////////////////////

short banderaUp = 0;
short banderaOk = 0;
short banderaDown = 0;
//Para opciones
int opcion = 0;

//char *txt;
int lect = 0;
unsigned int CargaTiempo = 0;
unsigned long cnt = 0;
unsigned long cntUser = 0;
unsigned long tiempo = 0;
unsigned int segundos=0;
unsigned int minutos=0;
unsigned int horas=0;
short timing = 0;
short decena = 0;
short espacio = 0;

//Variables para mecánica de los métodos
int tope = 0;
int j = 0;//indice de la eep
int desp = 0;

unsigned long Voltaje = 0;
unsigned long tlong = 0;
char ch;
int VoltInt = 0;

//variables para debuggueo por UART1
char txtLong[10];
char text[3];

void resetAll(){       //Se resetean todas las variables
    cuenta = 0;//contador de datos que llegan
    flag_rx = 0;//bandera de que la nextion mando info
    dato = 0;
    i = 0;
    flag_mv = 0;
    flag_end = 0;
    der = 0;
    a = 0;
    ////////////////
    banderaUp = 0;
    banderaOk = 0;
    banderaDown = 0;
    opcion = 0;
    lect = 0;
    CargaTiempo = 0;
    cnt =0;
    tiempo = 0;
    cntUser = 0;
    segundos = 0;
    minutos = 0;
    horas = 0;
    timing = 0;
    decena = 0;
    espacio = 0;
    i = 0;
    tope = 0;
    j = 0;
    desp = 0;
}

void initTMR0(){//Arranca el TMR0
  OPTION_REG = 0x82;
  TMR0  = 6;
  INTCON = 0xA0;
}

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
    if ((cuenta > 3) && ((unsigned char)trama[cuenta] == 0xff) && ((unsigned char)trama[cuenta-1] == 0xff) && ((unsigned char)trama[cuenta-2] == 0xff)){
      flag_rx = 1;//activa la bandera de que llego trama comple y ista para procesar
      CREN_bit = 0;  //DESHABILITA LA RECEPCION CONTINUA PARA LIMPIAR BUFFER    Y NO RECIBIR MIENTRA VA A NALIZAR
      INTCON.F7 = 0;  //deshabilita las interrpciones para poder procesar la trama
    }
    cuenta++;//incrementa contador o puntero del vectro de recibido
    //si es mayor que 30 debe limpiar la bandera y reiniciar el contador llego al maximo
    if (cuenta == 30){
      flag_rx = 0;
      cuenta = 0;
      flag_mv = 0;
    }
    PIR1.F5 = 0; //limpia el bit de interrupcion
  }
  if (TMR0IF_bit){
    flag_mv = 1;
    cnt++;
    TMR0IF_bit = 0;
    TMR0 = 6;
    if(cnt == 1000){//Aproximación a 1.03 segundos
       cntUser++;
       cnt = 0;
    }
    if(cntUser == tope){//Compara si ya pasó el tiempo que desea el usuario y apaga el módulo T0
       flag_end = 1;
       OPTION_REG = 0x00;
       TMR0 = 0;
       INTCON = 0x00;
    }
  }
}

//TRATAMIENTO DE SEÑAL
void procesa_Rx(){
  if (flag_rx == 1){//si la bandera de la trama esta activa
    //BITS DE RESIDUO POTENCIOMETRO
    if (strstr(trama,"t=")){
      flag_mv = 1;
      tope = atoi(trama[2]<<16)+atoi(trama[3]<<8)+atoi(trama[4]);
    }
    if(strstr(trama,"b=")){
      der = atoi(trama[2]);
    }
    memset(trama,0,30);
    cuenta = 0;  //limpia el contador
    flag_rx = 0; //limpia la bandera
    PIR1.F5 = 0; //limpia la bandera de interrpcion
    CREN_bit = 1;
    INTCON.F7 = 1;
  }
}

void mover_Graph(){
  //for(i = 0; i<255; i++){
  // 657 -D 10 bits
  //  255 -D 8 bits
  lect = ADC_Read(0);
    i = (unsigned int)(lect*255)/1023;//10 bits A 8 bits
    sprinti(envia,"add 8,0,");
    UART1_Write_Text(envia);
    sprinti(envia,"%d",i);
    UART1_Write_Text(envia);
    manda_serial_const("\xFF\xFF\xFF");
    Voltaje+=i;
    //sprinti(envia,"adc: %d",i);
    //UART1_Write_Text(envia);
  //}
}

void Mostrar(){// Dependiendo de la cantidad de muestras almacenadas en EEPROM, las desplegará en la LCD, una cada segundo
   tope = EEPROM_Read(0); // Capacidad de cada dirección EEPROM es de 0 a 255 decimal y hay 0-255 direcciones
   if(der){
     a++;
     if(a > tope){
       a = tope;
     }
   }else{
     a--;
     if(a == (-1)){
       a = 0;
     }
   }
   der = 0;
   j=a*4;
   sprinti(envia,"ViewSamples.text0.txt=\"");//para enviar texto
   lect = EEPROM_Read(j++);
   inttostr(lect,envia);
   UART1_Write_Text(envia);
   UART1_Write_Text(".");
   lect = EEPROM_Read(j++);
   inttostr(lect,envia);
   UART1_Write_Text(envia);
   lect = EEPROM_Read(j++);
   inttostr(lect,envia);
   UART1_Write_Text(envia);
   lect = EEPROM_Read(j++);
   inttostr(lect,envia);
   UART1_Write_Text(envia);
   UART1_Write_Text("V\"");
    manda_serial_const("\xFF\xFF\xFF");
}

void GuardarEEPROM(){
    Voltaje = Voltaje/Tope;
    i = EEPROM_Read(0)*4;
    tlong = (long)Voltaje * 5000;// Convertir el resultado en milivoltios
    tlong = tlong / 1023;        // 0..1023 -> 0-5000mV
    ch = tlong / 1000;           // Extraer voltios (miles de milivoltios)
    // del resultado
    EEPROM_Write(++i,ch);        //
    Delay_ms(20);
    ch = (tlong / 100) % 10;     // Extraer centenas de milivoltios
    EEPROM_Write(++i,ch);
    Delay_ms(20);
    ch = (tlong / 10) % 10;      // Extraer decenas de milivoltios
    EEPROM_Write(++i,ch);
    Delay_ms(20);
    ch = tlong % 10;             // Extraer unidades de milivoltios
    EEPROM_Write(++i,ch);
    Delay_ms(20);
    ch = EEPROM_Read(0);         // Extrae de la dirección 0 de EEPROM, que es la cantidad de muestras que
    ch++;                        //
    EEPROM_Write(0,ch);
    Voltaje = 0;                 // Resetea Voltaje, porque ya lo almacenó en EEPROM
}

void main(){
  ANSEL = 255;                           //Pines analogicos del puerto A, B desactivados
  ANSELH = 0;                          //Pines analogicos del puerto E desactivados
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
  cuenta = 0;
  UART1_Init(9600);
  memset(envia,0,30);
  ADC_Init();
  //habilita int serial
  PIR1.F5 = 0;
  PIE1.F5 = 1;
  INTCON.F6 = 1;
  INTCON.F7 = 1;
  while(1){
    if(flag_rx){
      procesa_Rx();
    }
    if(flag_mv){
      mover_Graph();
    }else if(flag_end){
      guardarEEPROM();
      resetAll();
    }
  }
}