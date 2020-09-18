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
char *encabezado = "Proyecto integr.";
char *muestreo = "Muestreo";
char *completado = "Completado";
char *visualizacion = "Visualizacion";
char *completada = "Completada";
//float ArrayFloat[10];
int lect = 0;
int valor = 0;
int cnt = 0;
unsigned long tiempo = 0;

//Variables para mecánica de los métodos
int i = 0;
int tope = 0;
int j = 0;
int captura = 0;

void resetAll(){       //Se resetean todas las variables
    banderaUp = 0;
    banderaOk = 0;
    banderaDown = 0;
    opcion = 0;
    i = 0;
    tope = 0;
    lect = 0;
    valor = 0;
    cnt =0;
    tiempo = 0;
/*   for(j=0;j<10;j++){
      ArrayFloat[j]=0;
   }*/
    j = 0;
}

void initTMR0(){//Arranca el TMR0

}

void cnfTMR0(){ //Configura/Alista el TMR0

}

void cnfTiempoLcd(){//Captura tiempo a muestrear (TMR0)

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
}

void Mostrar(){//Dentro del while, la i representa el índice de la memoria eeprom que se irá incrementando cada que
//encuentra el caracter '*' y el tope representa la cantidad de muestras que se tienen almacenadas
   Lcd_Cmd(_LCD_CLEAR);
   txt = "Mostrando data";
   Lcd_Out(1,1,txt);
   delay_ms(20);
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
   if(T0IF_bit){
      tiempo++;//segundos
        if(tiempo%captura==0){
        Muestrear();//capturas en arreglo e incrementas j del arreglo
      }
   
   }
}

void main() {
  ANSEL  = 255;                     // Configure AN pins as digital
  ANSELH = 0;
  TRISA = 0b00001101;
  TRISC = 0b10000111;
  PORTB = 0;
  //UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(100);                  // Wait for UART module to stabilize
  //UART1_Write_Text("Start");
  Lcd_Init();                        // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  Lcd_Out(1,1,encabezado);                 // Write text in first row
  Delay_ms(20);
  ADC_Init();
  cnfTMR0();
  while(1){
    if(UPBtn && banderaUp==0){
       banderaUp = 1;
       opcion = 1;
       txt = "Sample by time";
       Lcd_Out(2,1,txt);
       Delay_ms(20);
    }
    if(!UPBtn && banderaUp==1){
       banderaUp=0;
    }
    if(OKBtn && banderaOk==0){
       banderaOk = 1;
       Lcd_Cmd(_LCD_CLEAR);               // Clear display
       Lcd_Out(1,1,"Option selected");
       Lcd_Out(2,1,txt);
       Delay_ms(20);
    }
    if(!OKBtn && banderaOk==1){
       banderaOk=1;
    }
    if(DOWNBtn && banderaDown==0){
       banderaDown = 1;
       opcion = 2;
       txt = "View samples  ";
       Lcd_Out(2,1,txt);
       Delay_ms(20);
    }
    if(!DOWNBtn && banderaDown==1){
       banderaDown=0;
    }
    if(banderaOk == 1){
       if(opcion == 1){
          cnfTiempoLcd();//Captura tiempo ajustado por el usuario, pasar ese valor a términos de tope
          captura = tope/20;
          initTMR0();//Arranca timer
          Muestrear();
          GuardarEEPROM();
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          Lcd_Out(1,1,muestreo);
          Delay_ms(20);
          Lcd_Out(2,1,completado);
       }else if(opcion == 2){
          Mostrar();
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          Lcd_Out(1,1,visualizacion);
          Delay_ms(20);
          Lcd_Out(2,1,completada);
       }
       Delay_ms(500);
       Lcd_Cmd(_LCD_CLEAR);               // Clear display
       Lcd_Out(1,1,encabezado);                 // Write text in first row
       resetAll();
    }
  }
}