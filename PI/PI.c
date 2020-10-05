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

short banderaUp = 0;
short banderaOk = 0;
short banderaDown = 0;
//Para opciones
int opcion = 0;

int lect = 0;// Lectura en EEPROM
unsigned int CargaTiempo = 0;// El tiempo que quiere el usuario
unsigned long cnt = 0;// Para acumular tiempo con el timer0
unsigned long cntUser = 0;// Para delimitar el tiempo que desea el usuario
unsigned long tiempo = 0;
unsigned int segundos=0;
unsigned int minutos=0;
unsigned int horas=0;
short timing = 0;
short decena = 0;
short espacio = 0;

//Variables para mecánica de los métodos
int i = 0;
unsigned long tope = 0;
int j = 0;//indice de la EEPROM
int desp = 0;

unsigned long Voltaje = 0;
unsigned long tlong = 0;
char ch;
int VoltInt = 0;

//variables para debuggueo por UART1
char txtLong[10];
char text[20];


void resetAll(){       //Se resetean todas las variables
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


void procesarValor(int opc){
   espacio = 48+CargaTiempo;
   if(espacio  ==  58){//si CargaTiempo excede el 9, significa que se hará uso del espacio en blanco a la derecha
   //por lo tanto comenzarán a usarse las decenas y el CargaTiempo se resetea
      CargaTiempo = 0;
      if(desp == 0){//cuando sucede esto por primera vez, la variable decena trae el valor de -16, pero ahora se
      //debe setear a 0, para que al sumarse con 48, empiece la cuenta de decenas de forma correcta en el valor '0'
         decena = 0;
         desp = 1; //desplazamiento se activa, para que más adelante la decena no se vuelva -16
      }
      decena++;
   }
   if(espacio  ==  47){//si se trata de decrementar a la CargaTiempo de 0, este se irá a su límite superior
      CargaTiempo = 9;
      if(desp  ==  1){//cuando desplazamiento esté activado, significa que hay decenas cargadas, por lo tanto
      //las vamos decrementando
        decena--;
        if(decena  ==  0){//si la decena llega a 0, 'desp'lazamient se vuelve 0, para que adquiera el valor de -16
        //y en donde estaba una decena, se imprime el espacio en blanco (-16+48 = 32)
          desp = 0;
        }
      }
   }
   switch(opc){
      case 1://horas
      Lcd_Chr(1,13,decena+48);
      Lcd_Chr(1,14,48+CargaTiempo);
      horas = decena*10+CargaTiempo;
      break;
      case 2://minutos
      Lcd_Chr(2,5,decena+48);
      Lcd_Chr(2,6,48+CargaTiempo);
      minutos = decena*10+CargaTiempo;
      break;
 case 3://horas
      Lcd_Chr(2,13,decena+48);
      Lcd_Chr(2,14,48+CargaTiempo);
      segundos = decena*10+CargaTiempo;
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
  CargaTiempo = 0;
  while(timing != 4){//timing sirve para saber en qué unidad de tiempo se está ajustando el parámetro
    if(UPBtn && banderaUp == 0){//incrementa unidades de tiempo con el botón de UP
       banderaUp = 1;
       CargaTiempo++;
       procesarValor(timing);//dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
    }
    if(!UPBtn && banderaUp == 1){
       banderaUp=0;
    }
    if(OKBtn && banderaOk == 0){//Se acepta el valor cargado en las unidades de tiempo, se incrementa al siguiente
    //ajuste de parámetro (unidades de tiempo), se resetean las variables usadas en 'procesarValor(timing)'
       banderaOk = 1;
       decena = 0;
       CargaTiempo = 0;
       desp = 0;
    }
    if(!OKBtn && banderaOk == 1){//Cuando se suelta el botón de OK, se verifica que se haya cargado algún valor diferente a
      //0, si ese es el caso, se escribe 00 en el ajuste de tiempo que el usuario dejó pasar
       banderaOk = 0;
       switch(timing){
          case 1:
          if(horas == 0){
            Lcd_Chr(1,13,'0');
            Lcd_Chr(1,14,'0');
          }
          break;
          case 2:
          if(minutos == 0){
            Lcd_Chr(2,5,'0');
            Lcd_Chr(2,6,'0');
          }/**/
          break;
          case 3:
          if(segundos == 0){
            Lcd_Chr(2,13,'0');
            Lcd_Chr(2,14,'0');
          }
          break;
       }
       timing++;
    }
    if(DOWNBtn && banderaDown == 0){//Decrementa unidades de tiempo con el botón Down
       banderaDown = 1;
       CargaTiempo--;
       procesarValor(timing);//Dependiendo de la carga, lo procesa y lo pasa a caracter imprimible por la lcd
    }
    if(!DOWNBtn && banderaDown == 1){//Banderas que evitan que el presionado del botón se replique n veces
       banderaDown=0;
    }
  }
  tope = horas*360+minutos*60+segundos;//Tope está en términos de 'segundos'; por lo tanto los valores extraidos
  //se pasan a segundos
}

void GuardarEEPROM(){
    i = EEPROM_Read(0)*4;
    tlong = (long)Voltaje * 5000;// Convertir el resultado en milivoltios
    tlong = tlong / 1023;        // 0..1023 -> 0-5000mV
    ch = tlong / 1000;           // Extraer voltios (miles de milivoltios)
    // del resultado
    Lcd_Chr(2,9,48+ch);          // Escribir resultado en formato ASCII
    EEPROM_Write(++i,ch);        // 
    Delay_ms(20);
    Lcd_Chr_CP('.');
    ch = (tlong / 100) % 10;     // Extraer centenas de milivoltios
    Lcd_Chr_CP(48+ch);           // Escribir resultado en formato ASCII
    EEPROM_Write(++i,ch);
    Delay_ms(20);
    ch = (tlong / 10) % 10;      // Extraer decenas de milivoltios
    Lcd_Chr_CP(48+ch);           // Escribir resultado en formato ASCII
    EEPROM_Write(++i,ch);
    Delay_ms(20);
    ch = tlong % 10;             // Extraer unidades de milivoltios
    Lcd_Chr_CP(48+ch);           // Escribir resultado en formato ASCII
    EEPROM_Write(++i,ch);
    Delay_ms(20);
    Lcd_Chr_CP('V');
    ch = EEPROM_Read(0);         // Extrae de la dirección 0 de EEPROM, que es la cantidad de muestras que
    ch++;                        // 
    EEPROM_Write(0,ch);
    Voltaje = 0;                 // Resetea Voltaje, porque ya lo almacenó en EEPROM
    Delay_ms(2000);
}

void Muestrear(){//Lee el canal 0 analógico y lo va acumulando en la variable Voltaje, para promediarlo al final del muestreo
   RB0_bit = ~RB0_bit;
   LongToStr(Voltaje,text);
   /*UART1_Write_Text(text);
   UART1_Write_Text("\r\n");*/
   Voltaje+=ADC_Read(0);
}

void Mostrar(){// Dependiendo de la cantidad de muestras almacenadas en EEPROM, las desplegará en la LCD, una cada segundo
   Lcd_Out(1,1,"Mostrando data");
   delay_ms(300);
   tope = EEPROM_Read(0); // Capacidad de cada dirección EEPROM es de 0 a 255 decimal y hay 0-255 direcciones
   /*UART1_Write_Text("\r\n");
   UART1_Write_Text("Tope:");
   LongToStr(tope,txtLong);
   UART1_Write_Text(txtLong);*/
   i = 0;// Cuenta la cantidad de muestras
   j = 1;// Cuenta las direcciones de EEPROM 1-255 direcciones, Inicia en 1, porque la direccion 0
   // Es el tope o la cantidad de muestras que se han hecho
   VoltInt = 0;
   cnt = 6;
   while(i<tope){
      lect = EEPROM_Read(j);
      j++;
      VoltInt++;
      cnt++;
      if(VoltInt != 6 && VoltInt != 2){
         Lcd_Chr(2,cnt,lect+48);
        Delay_ms(50);
      }else if(VoltInt == 2){
        Delay_ms(50);
        Lcd_Chr(2,cnt,'.');
        j--; // Como se colocó un punto y no un valor de EEPROM, el incremento se anula con un decremento 
        // a la misma variable en esta situación
      }else{//VoltInt  ==  6
        i++;
        j--;// Como no se escribe un valor de EEPROM, y se incrementó en la parte de arriba,
        // aquí se decrementa
        Lcd_Chr_CP('V');
        cnt = 6;
        VoltInt = 0;
        Delay_ms(1000);
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1,1,"Mostrando data");
      }
   }
}

void interrupt(){
  if (TMR0IF_bit){
    cnt++;
    TMR0IF_bit = 0;
    TMR0 = 6;
    if(cnt == 1000){//Aproximación a 1.03 segundos
       cntUser++;
       cnt = 0;
    }
    if(cntUser == tope){//Compara si ya pasó el tiempo que desea el usuario y apaga el módulo T0
       RB1_bit = ~RB1_bit;//Debuggeo físico
       OPTION_REG = 0x00;
       TMR0 = 0;
       INTCON = 0x00;
    }
  }
}

void main() {
  ANSEL  = 255;                   // Configura AN pins como analógicos
  ANSELH = 0;
  TRISA = 0b00001101;             // A3[VREF+],A2[VREF-],A0[ADC]
  TRISC = 0b10000111;             // C7[TX],C6[RX],C2[Bdown],C1[Bok],C0[Bup]
  TRISB0_bit = 0;                 // Debbuggeo físico
  TRISB1_bit = 0;
  PORTB = 0;
  UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(100);                  // Wait for UART module to stabilize
  UART1_Write_Text("Start");
  Lcd_Init();                     // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);            // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);       // Cursor off
  Lcd_Chr(1,1,'P');
  Lcd_Chr_CP('r');
  Lcd_Chr_CP('o');
  Lcd_Chr_CP('y');
  Lcd_Chr_CP('e');
  Lcd_Chr_CP('c');
  Lcd_Chr_CP('t');
  Lcd_Chr_CP('o');
  Delay_ms(500);
  ADC_Init();
  while(1){
    if(UPBtn && banderaUp == 0){
       banderaUp = 1;
       opcion = 1;
       Lcd_Out(2,1,"Sample by time");
       Delay_ms(500);
    }
    if(!UPBtn && banderaUp == 1){
       banderaUp = 0;
    }
    if(OKBtn && banderaOk == 0){
       banderaOk = 1;
    }
    if(DOWNBtn && banderaDown == 0){
       banderaDown = 1;
       opcion = 2;
       Lcd_Out(2,1,"View samples  ");
       Delay_ms(500);
    }
    if(!DOWNBtn && banderaDown == 1){
       banderaDown = 0;
    }
    if(banderaOk == 1){
       if(opcion == 1){
          cnfTiempoLcd();//Captura tiempo ajustado por el usuario, pasa ese valor a términos de tope
          initTMR0();//Arranca timer, va implícito dentro de la interrupción Muestrear();
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1,3,"Muestreando");
          Lcd_Out(2,7,"...");
          while(cntUser < tope){
             if(cnt == 999){//Antes de que se acabe el segundo, muestrea
                 muestrear();
             }
          }
          /*UART1_Write_Text("\r\n");
          UART1_Write_Text("Voltaje sin dividir:");
          LongToStr(Voltaje,txtLong);
          UART1_Write_Text(txtLong);
          UART1_Write_Text("\r\n");
          Voltaje=Voltaje/tope;
          UART1_Write_Text("Voltaje dividido:");
          LongToStr(Voltaje,txtLong);
          UART1_Write_Text(txtLong);
          UART1_Write_Text("\r\n");
          UART1_Write_Text("Tope:");
          LongToStr(tope,txtLong);
          UART1_Write_Text(txtLong);
          UART1_Write_Text("\r\n");*/
          GuardarEEPROM();
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1,1,"muestreo");
          Delay_ms(50);
          Lcd_Out(2,1,"completo");
       }else if(opcion == 2){
          Mostrar();
          Lcd_Cmd(_LCD_CLEAR);
          Lcd_Out(1,1,"vista");
          Delay_ms(50);
          Lcd_Out(2,1,"completa");
       }
       Delay_ms(500);
       resetAll();
       Lcd_Cmd(_LCD_CLEAR);
       Lcd_Out(1,1,"Proyecto Integr");
    }
  }
}