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
// End LCD module connections
//Para botones
sbit UPBtn at RC0_bit;
sbit OKBtn at RC1_bit;
sbit DOWNBtn at RC2_bit;

int banderaUp = 0;
int banderaOk = 0;
int banderaDown = 0;
//Para opciones
int opcion = 0;

char *txt;
int lect = 0;
unsigned int valor = 0;
unsigned long cnt = 0;
unsigned long cntUser = 0;
unsigned long tiempo = 0;
unsigned int segundos=0;
unsigned int minutos=0;
unsigned int horas=0;
int timing = 0;
int decena = 0;
int espacio = 0;
int animacion = 0;
int bndAnimacion = 0;

//Variables para mecánica de los métodos
int i = 0;
int tope = 0;
int j = 0;//indice de la eep
int desp = 0;

void resetAll(){       //Se resetean todas las variables
    banderaUp = 0;
    banderaOk = 0;
    banderaDown = 0;
    opcion = 0;
    lect = 0;
    valor = 0;
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


void procesarValor(int opc){
   espacio = 48+valor;
   if(espacio == 58){//si valor excede el 9, significa que se hará uso del espacio en blanco a la derecha
   //por lo tanto comenzarán a usarse las decenas y el valor se resetea
      valor = 0;
      if(desp==0){//cuando sucede esto por primera vez, la variable decena trae el valor de -16, pero ahora se
      //debe setear a 0, para que al sumarse con 48, empiece la cuenta de decenas de forma correcta en el valor '0'
         decena = 0;
         desp = 1; //desplazamiento se activa, para que más adelante la decena no se vuelva -16
      }
      decena++;
   }
   if(espacio == 47){//si se trata de decrementar al valor de 0, este se irá a su límite superior
      valor = 9;
      if(desp == 1){//cuando desplazamiento esté activado, significa que hay decenas cargadas, por lo tanto
      //las vamos decrementando
        decena--;
        if(decena == 0){//si la decena llega a 0, 'desp'lazamient se vuelve 0, para que adquiera el valor de -16
        //y en donde estaba una decena, se imprime el espacio en blanco (-16+48 = 32)
          desp = 0;
        }
      }
   }
   if(desp!=1){//si no se ha hecho un 'desp'lazamiento o más bien ocupado el espacio libre a la izquierda
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
   Delay_ms(100);
}

void cnfTiempoLcd(){//Captura tiempo a muestrear (TMR0)
  timing = 1;
  desp = 0;
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  //Delay_ms(100);
  //Imprime plantillas de tiempo
  Lcd_Out(1,1,"Tiempo: ");
  Delay_ms(50);
  Lcd_Out(1,9,"Hrs[  ]");
  Delay_ms(50);
  Lcd_Out(2,1,"Min[  ]");
  Delay_ms(50);
  Lcd_Out(2,9,"Seg[  ]");
  Delay_ms(50);
  valor = 0;
  while(timing != 4){//timing sirve para saber en qué unidad de tiempo se está ajustando el parámetro
    if(UPBtn && banderaUp==0){//incrementa unidades de tiempo con el botón de UP
       banderaUp = 1;
       valor++;
       procesarValor(timing);//dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
    }
    if(!UPBtn && banderaUp==1){
       banderaUp=0;
    }
    if(OKBtn && banderaOk==0){//Se acepta el valor cargado en las unidades de tiempo, se incrementa al siguiente
    //ajuste de parámetro (unidades de tiempo), se resetean las variables usadas en 'procesaarValor(timing)'
       timing++;
       banderaOk = 1;
       decena = 0;
       valor = 0;
       desp = 0;
    }
    if(!OKBtn && banderaOk==1){
       banderaOk=0;
    }
    if(DOWNBtn && banderaDown==0){//Decrementa unidades de tiempo con el botón Down
       banderaDown = 1;
       valor--;
       procesarValor(timing);//dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
    }
    if(!DOWNBtn && banderaDown==1){
       banderaDown=0;
    }
  }
  tope = horas*360+minutos*60+segundos;
}

void GuardarEEPROM(){
    //PROMEDIO(Array);
    //Tecnica(ConversionFloatAInt);//Extrae número a número y lo guarda en EEPROM
    //EEPROM[0]=EEPROM[0]+1;
    //EEPROM_Write(0,0);
}

void Muestrear(){//Dentro del while, la i representa el tiempo que se irá incrementando en la interrupción del
//TMR0 y el tope, los segundos/minutos ajustados por el usuario
//FUNCION ESCLAVA DE LA INTERRUPCIÓN DE TIMER 0
   RB0_bit = ~RB0_bit;
}

void Mostrar(){//Dentro del while, la i representa el índice de la memoria eeprom que se irá incrementando cada que
//encuentra el caracter '*' y el tope representa la cantidad de muestras que se tienen almacenadas
   //txt = "Mostrando data";
   Lcd_Out(1,1,"Mostrando data");
   delay_ms(300);
   //tope = EEPROM_Read(0); // capacidad es de 0 a 255 decimal
   tope = 0;
   i = 0;
   j = 1;//se va moviendo en las direcciones de eeprom 1-255 direcciones, Inicia en 1, porque la direccion 0
   //Es el tope o la cantidad de muestras que se han hecho
   cnt = 6;
   while(i<tope){
      lect = EEPROM_Read(j);
      j++;
      if(lect != 7){
         Lcd_Chr(2,cnt,lect);
      }else{
         Lcd_Chr(2,cnt,'.');
      }
      cnt++;
      if(lect == '*'){
        i++;
        Lcd_Chr_CP('V');
        cnt = 6;
        Delay_ms(1000);
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,1,txt);
      }
   }
}

void interrupt(){
  if (TMR0IF_bit){
    cnt++;
    TMR0IF_bit = 0;
    TMR0 = 6;
    //Enter your code here
    if(cnt>1000){
       cntUser++;
       muestrear();
       cnt=0;
    }
    if(cntUser==tope){
       RB1_bit=~RB1_bit;
       OPTION_REG = 0x00;
       TMR0 = 0;
       INTCON = 0x00;
    }
  }
}

void main() {
  ANSEL  = 255;                     // Configure AN pins as digital
  ANSELH = 0;
  TRISA = 0b00001101;
  TRISC = 0b10000111;
  TRISB0_bit = 0;
  TRISB1_bit = 0;
  PORTB = 0;
  //UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(100);                  // Wait for UART module to stabilize
  //UART1_Write_Text("Start");
  Lcd_Init();                        // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  Lcd_Chr(1,1,'P');
  Lcd_Chr_CP('r');
  Lcd_Chr_CP('o');
  Lcd_Chr_CP('y');
  Lcd_Chr_CP('e');
  Lcd_Chr_CP('c');
  Lcd_Chr_CP('t');
  Lcd_Chr_CP('o');
  //Lcd_Out(1,1,"Proyecto Integr");                 // Write text in first row
  Delay_ms(500);
  ADC_Init();
  while(1){
    //Lcd_Out(1,1,"Proyecto Integr.");
    if(UPBtn && banderaUp==0){
       banderaUp = 1;
       opcion = 1;
       txt = "Sample by time";
       Lcd_Out(2,1,txt);
       Delay_ms(500);
    }
    if(!UPBtn && banderaUp==1){
       banderaUp=0;
    }
    if(OKBtn && banderaOk==0){
       banderaOk = 1;
    }
    if(!OKBtn && banderaOk==1){
       banderaOk=1;
    }
    if(DOWNBtn && banderaDown==0){
       banderaDown = 1;
       opcion = 2;
       //txt = "View samples  ";
       Lcd_Out(2,1,"View samples  ");
       Delay_ms(500);
    }
    if(!DOWNBtn && banderaDown==1){
       banderaDown=0;
    }
    if(banderaOk == 1){
       if(opcion == 1){
          cnfTiempoLcd();//Captura tiempo ajustado por el usuario, pasa ese valor a términos de tope
          initTMR0();//Arranca timer, va implícito dentro de la interrupción Muestrear();
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1,3,"Muestreando");
          Lcd_Out(2,7,"...");
          while(cntUser<tope){
          }
          //GuardarEEPROM();
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          Lcd_Out(1,1,"muestreo");
          Delay_ms(50);
          Lcd_Out(2,1,"completo");
       }else if(opcion == 2){
          Mostrar();
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          Lcd_Out(1,1,"vista");
          Delay_ms(50);
          Lcd_Out(2,1,"completa");
       }
       Delay_ms(500);
       resetAll();
       Lcd_Cmd(_LCD_CLEAR);               // Clear display
       Lcd_Out(1,1,"Proyecto Integr");                 // Write text in first row
    }
  }
}