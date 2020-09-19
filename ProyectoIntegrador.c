//// LCD module connections
sbit LCD_RS at RB7_bit;
sbit LCD_EN at RB6_bit;
sbit LCD_D4 at RB5_bit;
sbit LCD_D5 at RB4_bit;
sbit LCD_D6 at RB3_bit;
sbit LCD_D7 at RB2_bit;

sbit LCD_RS_Direction at TRISB7_bit;
sbit LCD_EN_Direction at TRISB6_bit;
sbit LCD_D4_Direction at TRISB5_bit;
sbit LCD_D5_Direction at TRISB4_bit;
sbit LCD_D6_Direction at TRISB3_bit;
sbit LCD_D7_Direction at TRISB2_bit;

sbit UPBtn at RC0_bit;
sbit OKBtn at RC1_bit;
sbit DOWNBtn at RC2_bit;

int banderaUp = 0;
int banderaOk = 0;
int banderaDown = 0;
int opcion = 0;
int espacio = 0;
int desp = 0;
int decena = 0;
int minutos = 0;
int segundos = 0;
int timing = 0;
int horas = 0;

short lectura;
int ultimo = 0;

int cmpTope;
int cmpData;
int recorre;

int valor = 0;
unsigned long cnt = 0;
unsigned long cntUser = 0;
unsigned long tiempo = 0;
int increm =0;

//Variables para mec�nica de los m�todos
int i = 0;
int tope = 0; //tiempo definido por el usuario para muestrear
int j = 0;
int captura = 0;

//-------------------------------------------------------------------------------

void muestrear();

void resetAll(){       //Se resetean todas las variables
    cntUser = 0;
    banderaUp = 0;
    banderaOk = 0;
    banderaDown = 0;
    opcion = 0;
    i = 0;
    tope = 0;
    valor = 0;
    cnt =0;
    tiempo = 0;
    j = 0;
}

void Title(){
    Lcd_Cmd(_LCD_CLEAR);               // Clear display
    Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
    Lcd_Out(1,1,"proyect-muestreo");                 // Write text in first row
    Delay_ms(500);
}

void initTMR0(){//Arranca el TMR0
  OPTION_REG         = 0x82;
  TMR0                 = 6;
  INTCON         = 0xA0;
}

void interrupt(){
  if (TMR0IF_bit){
    cnt++;
    TMR0IF_bit         = 0;
    TMR0                 = 6;
    //Enter your code here
    if(cnt>1000){
       cntUser++;
       RB0_bit=~RB0_bit;
       cnt=0;
    }
    if(cntUser==tope){
           RB1_bit=~RB1_bit;
           OPTION_REG         = 0x00;
           TMR0                 = 0;
           INTCON         = 0x00;
    }

  }

}

// CAPTURAR TIEMPOS DE MUESTREO DEFINIDOS POR USUARIO
void procesarValor(int opc){
   espacio = 48+valor;
   if(espacio == 58){//si valor excede el 9, significa que se har� uso del espacio en blanco a la derecha
   //por lo tanto comenzar�n a usarse las decenas y el valor se resetea
      valor = 0;
      if(desp==0){//cuando sucede esto por primera vez, la variable decena trae el valor de -16, pero ahora se
      //debe setear a 0, para que al sumarse con 48, empiece la cuenta de decenas de forma correcta en el valor '0'
         decena = 0;
         desp = 1; //desplazamiento se activa, para que m�s adelante la decena no se vuelva -16
      }
      decena++;
   }
   if(espacio == 47){//si se trata de decrementar al valor de 0, este se ir� a su l�mite superior
      valor = 9;
      if(desp == 1){//cuando desplazamiento est� activado, significa que hay decenas cargadas, por lo tanto
      //las vamos decrementando
        decena--;
        if(decena == 0){//si la decena llega a 0, 'desp'lazamient se vuelve 0, para que adquiera el valor de -16
        //y en donde estaba una decena, se imprime el espacio en blanco (-16+48 = 32)
          desp = 0;
        }
      }
   }
   if(desp!=1){//si no se ha hecho un 'desp'lazamiento o m�s bien ocupado el espacio libre a la izquierda
   //se carga con -16, para que al sumarse con 48, se genere el valor 32 que es un espacio en blanco en ASCII
      decena = -16;
   }

   switch(opc){
      case 1://horas
      Lcd_Chr(1,13,decena+48);
      Lcd_Chr(1,14,48+valor);
      if(decena == -16){
        decena = 0;
      }
      horas = decena*10+valor;
      break;
      case 2://minutos
      Lcd_Chr(2,5,decena+48);
      Lcd_Chr(2,6,48+valor);
      if(decena == -16){
        decena = 0;
      }
      minutos = decena*10+valor;
      break;
 case 3://horas
      Lcd_Chr(2,13,decena+48);
      Lcd_Chr(2,14,48+valor);
      if(decena == -16){
        decena = 0;
      }
      segundos = decena*10+valor;
      break;
   }
   Delay_ms(200);
}

//CAPTURA TIEMPOS A MUESTREAR TMR0
void cnfTiempoLcd(){//Captura tiempo a muestrear (TMR0)
  timing = 1;
  desp = 0;
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Delay_ms(50);
  //Imprime plantillas de tiempo
  Lcd_Out(1,1,"time: ");
  Delay_ms(50);
  Lcd_Out(1,9,"hrs[  ]");
  Delay_ms(50);
  Lcd_Out(2,1,"min[  ]");
  Delay_ms(50);
  Lcd_Out(2,9,"seg[  ]");
  Delay_ms(50);
  valor = 0;
  while(timing != 4){//timing sirve para saber en qu� unidad de tiempo se est� ajustando el par�metro
    if(UPBtn && banderaUp==0){//incrementa unidades de tiempo con el bot�n de UP
       banderaUp = 1;
       valor++;
       procesarValor(timing);//dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
       Delay_ms(50);
    }
    if(!UPBtn && banderaUp==1){
       banderaUp=0;
    }
    if(OKBtn && banderaOk==0){//Se acepta el valor cargado en las unidades de tiempo, se incrementa al siguiente
    //ajuste de par�metro (unidades de tiempo), se resetean las variables usadas en 'procesaarValor(timing)'
       timing++;
       banderaOk = 1;
       decena = 0;
       valor = 0;
       desp = 0;
    }
    if(!OKBtn && banderaOk==1){
       banderaOk=0;
    }
    if(DOWNBtn && banderaDown==0){//Decrementa unidades de tiempo con el bot�n Down
       banderaDown = 1;
       valor--;
       procesarValor(timing);//dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
       Delay_ms(50);
    }
    if(!DOWNBtn && banderaDown==1){
       banderaDown=0;
    }
  }
  tope = horas*360+minutos*60+segundos;
}

void muestrear(){
     RB0_bit=~RB0_bit;
}

void Mostrar(){//Dentro del while, la i representa el �ndice de la memoria eeprom que se ir� incrementando cada que
     cmpTope = 1;
     cmpData = 1;
     recorre = 1;
     Lcd_Cmd(_LCD_CLEAR);
          while(cmpTope <= 4){
             while(cmpData <= 5){
                if(cmpData==2){
                   Lcd_Out(2,4+cmpData,".");
                   Delay_ms(50);
                }else{
                   Lcd_Chr(2,4+cmpData,48+EEPROM_Read(recorre));
                   Delay_ms(100);
                   recorre++;
                }
                //Delay_ms(1000);
                cmpData++;
             }
             Lcd_Out(2,10,"V");
             Delay_ms(500);
             cmpTope++;
          }
}

//------------------------------------------------------------------------------

void main() {
  ANSEL  = 255;                     // Configure AN pins as digital
  ANSELH = 0;
  TRISA = 0b00001101;
  TRISC = 0b10000111;
  TRISD = 0x00;
  PORTD = 0;
  TRISB0_bit=0;
  TRISB1_bit=0;
  PORTB = 0;
  UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(100);                  // Wait for UART module to stabilize
  //UART1_Write_Text("Start");
  Lcd_Init();                        // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  /*Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  Lcd_Out(1,1,"proyect-muestreo");                 // Write text in first row
  Delay_ms(500);*/
  Title();
  ADC_Init();

  //ciclo principal
  while(1){
    if(UPBtn && banderaUp==0){ //muestra opcion muestrear en el manu
       banderaUp = 1;
       opcion = 1;
       Lcd_Out(2,1,"muestrear");
       Delay_ms(500);

    }
    if(!UPBtn && banderaUp==1){
       banderaUp=0;
    }
    if(OKBtn && banderaOk==0){ //cuando alguna opcion del menu se selecciona
       banderaOk = 1;
       Lcd_Cmd(_LCD_CLEAR);
       Delay_ms(20);
    }
    if(!OKBtn && banderaOk==1){
       banderaOk=1;
    }
    if(DOWNBtn && banderaDown==0){
       banderaDown = 1;
       opcion = 2;

       Lcd_Out(2,1,"visualizar");
       Delay_ms(500);
    }
    if(!DOWNBtn && banderaDown==1){ // opcion de Mostrar muestreos guardados
       banderaDown=0;
    }
    
    //aqui entra una vez seleccionado una opcion del menu
    if(banderaOk == 1){
       if(opcion == 1){//si la opcion elegida fue Muestrear un determinado tiempo
          cnfTiempoLcd();
          //Delay_ms(100);
          initTMR0();//Arranca timer
          
          //muestreos x segundo
          ultimo = 5;
          while(cntUser < tope){
                     Lcd_Cmd(_LCD_CLEAR);
                     Lcd_Out(1,1,"trabajando");
                     Delay_ms(200);
          }
       
       //prueba de almacenamiento eeprom para probar visualizacion
          lectura=1;
          while(lectura<=16){
          EEPROM_Write(0x00+lectura,lectura);
          lectura++;
          }
       
          EEPROM_Write(0x00,0x00+4);

             //GuardarEEPROM();
             //RB1_bit=~RB1_bit;
             Lcd_Cmd(_LCD_CLEAR);
             Delay_ms(200);
             Lcd_Out(1,1,"muestreo");
             Delay_ms(50);
             Lcd_Out(2,1,"listo");
             Delay_ms(300);
             RB0_bit=0;
             RB1_bit=0;
             

       }else if(opcion == 2){// si la opcion elegida es mostrar los muestreos guardados
          Mostrar();
          Lcd_Cmd(_LCD_CLEAR);
          Delay_ms(200);
          Lcd_Out(1,1,"vista");
          Delay_ms(50);
          Lcd_Out(2,1,"completa");
       }
       resetAll();
       Title();
    }
  }
}