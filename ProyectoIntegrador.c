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
sbit UPBot at RC0_bit;
sbit OKBot at RC1_bit;
sbit DOWNBot at RC2_bit;

int banderaUp = 0;
int banderaOk = 0;
int banderaDown = 0;
//Para opciones
int opcMuestrear = 0;
int opcMostrar = 0;
int opcConfirmar = 0;

char *txt;
float ArrayFloat[20];
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
    opcMuestrear = 0;
    opcMostrar = 0;
    opcConfirmar = 0;
    banderaUp = 0;
    banderaOk = 0;
    banderaDown = 0;
    i = 0;
    tope = 0;
    lect = 0;
    valor = 0;
    cnt =0;
    tiempo = 0;
   for(j=0;j<20;j++){
      ArrayFloat[j]=0;
   }
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
}

void Muestrear(){//Dentro del while, la i representa el tiempo que se irá incrementando en la interrupción del
//TMR0 y el tope, los segundos/minutos ajustados por el usuario
//FUNCION ESCLAVA DE LA INTERRUPCIÓN DE TIMER 0
}
void Mostrar(){//Dentro del while, la i representa el índice de la memoria eeprom que se irá incrementando cada que
//encuentra el caracter '*' y el tope representa la cantidad de muestras que se tienen almacenadas
   Lcd_Cmd(_LCD_CLEAR);
   Lcd_Out(1,1,"Mostrando data");
   tope = EEPROM_Read(0); // capacidad es de 0 a 255 decimal
   i = 0;
   j = 1;//se va moviendo en las direcciones de eeprom 1-255 direcciones, Inicia en 1, porque la direccion 0
   //Es el tope o la cantidad de muestras que se han hecho
   cnt = 6;
   while(i<tope){
      lect = EEPROM_Read(j);
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
        Lcd_Out(1,1,"Mostrando data");
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
  UART1_Init(9600);               // Initialize UART module at 9600 bps
  Delay_ms(100);                  // Wait for UART module to stabilize
  UART1_Write_Text("Start");
  Lcd_Init();                        // Initialize LCD
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  Lcd_Out(1,1,"Proyecto Integr.");                 // Write text in first row
  Delay_ms(20);
  ADC_Init();
  cnfTMR0();
  while(1){
     if(opcConfirmar == 0) {//
       if(UPBot && banderaUp==0){
          banderaUp = 1;
          opcMuestrear = 1;
          opcMostrar = 0;
          txt = "MuestreoXtiempo";
          Lcd_Out(2,1,txt);
          Delay_ms(20);
       }
       if(!UPBot && banderaUp==1){
          banderaUp=0;
       }
       if(OKBot && banderaOk==0){
          banderaOk = 1;
          opcConfirmar = 1;
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          Lcd_Out(1,2,"Opcion selecc");
          Lcd_Out(2,1,txt);
          Delay_ms(20);
       }
       if(!OKBot && banderaOk==1){
          banderaOk=0;
       }
       if(DOWNBot && banderaDown==0){
          banderaDown = 1;
          opcMuestrear = 0;
          opcMostrar = 1;
          txt = "Mostrar muestras";
          Lcd_Out(2,1,txt);
          Delay_ms(20);
       }
       if(!DOWNBot && banderaDown==1){
          banderaDown=0;
       }
    }
    if(opcConfirmar == 1){
       if(opcMuestrear){
          cnfTiempoLcd();//Captura tiempo ajustado por el usuario, pasar ese valor a términos de tope
          captura = tope/20;
          initTMR0();//Arranca timer
          Muestrear();
          GuardarEEPROM();
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          Lcd_Out(1,1,"Muestreo");
          Lcd_Out(2,1,"Completo");
       }else{
          Mostrar();
          Lcd_Cmd(_LCD_CLEAR);               // Clear display
          Lcd_Out(1,1,"Visualizacion");
          Lcd_Out(2,1,"Completa");
       }
       resetAll();
       Lcd_Cmd(_LCD_CLEAR);               // Clear display
       Lcd_Out(1,1,"Proyecto Integr.");                 // Write text in first row
       Delay_ms(20);
    }
  }
}