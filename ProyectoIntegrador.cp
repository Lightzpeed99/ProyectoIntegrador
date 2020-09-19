#line 1 "C:/Users/juan carlos tlaxcala/Documents/pic/ProyectInt/code2/ProyectoIntegrador-master/ProyectoIntegrador.c"

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


int i = 0;
int tope = 0;
int j = 0;
int captura = 0;



void muestrear();

void resetAll(){
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
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"proyect-muestreo");
 Delay_ms(500);
}

void initTMR0(){
 OPTION_REG = 0x82;
 TMR0 = 6;
 INTCON = 0xA0;
}

void interrupt(){
 if (TMR0IF_bit){
 cnt++;
 TMR0IF_bit = 0;
 TMR0 = 6;

 if(cnt>1000){
 cntUser++;
 RB0_bit=~RB0_bit;
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


void procesarValor(int opc){
 espacio = 48+valor;
 if(espacio == 58){

 valor = 0;
 if(desp==0){

 decena = 0;
 desp = 1;
 }
 decena++;
 }
 if(espacio == 47){
 valor = 9;
 if(desp == 1){

 decena--;
 if(decena == 0){

 desp = 0;
 }
 }
 }
 if(desp!=1){

 decena = -16;
 }

 switch(opc){
 case 1:
 Lcd_Chr(1,13,decena+48);
 Lcd_Chr(1,14,48+valor);
 if(decena == -16){
 decena = 0;
 }
 horas = decena*10+valor;
 break;
 case 2:
 Lcd_Chr(2,5,decena+48);
 Lcd_Chr(2,6,48+valor);
 if(decena == -16){
 decena = 0;
 }
 minutos = decena*10+valor;
 break;
 case 3:
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


void cnfTiempoLcd(){
 timing = 1;
 desp = 0;
 Lcd_Cmd(_LCD_CLEAR);
 Delay_ms(50);

 Lcd_Out(1,1,"time: ");
 Delay_ms(50);
 Lcd_Out(1,9,"hrs[  ]");
 Delay_ms(50);
 Lcd_Out(2,1,"min[  ]");
 Delay_ms(50);
 Lcd_Out(2,9,"seg[  ]");
 Delay_ms(50);
 valor = 0;
 while(timing != 4){
 if(UPBtn && banderaUp==0){
 banderaUp = 1;
 valor++;
 procesarValor(timing);
 Delay_ms(50);
 }
 if(!UPBtn && banderaUp==1){
 banderaUp=0;
 }
 if(OKBtn && banderaOk==0){

 timing++;
 banderaOk = 1;
 decena = 0;
 valor = 0;
 desp = 0;
 }
 if(!OKBtn && banderaOk==1){
 banderaOk=0;
 }
 if(DOWNBtn && banderaDown==0){
 banderaDown = 1;
 valor--;
 procesarValor(timing);
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

void Mostrar(){
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

 cmpData++;
 }
 Lcd_Out(2,10,"V");
 Delay_ms(500);
 cmpTope++;
 }
}



void main() {
 ANSEL = 255;
 ANSELH = 0;
 TRISA = 0b00001101;
 TRISC = 0b10000111;
 TRISD = 0x00;
 PORTD = 0;
 TRISB0_bit=0;
 TRISB1_bit=0;
 PORTB = 0;
 UART1_Init(9600);
 Delay_ms(100);

 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
#line 260 "C:/Users/juan carlos tlaxcala/Documents/pic/ProyectInt/code2/ProyectoIntegrador-master/ProyectoIntegrador.c"
 Title();
 ADC_Init();


 while(1){
 if(UPBtn && banderaUp==0){
 banderaUp = 1;
 opcion = 1;
 Lcd_Out(2,1,"muestrear");
 Delay_ms(500);

 }
 if(!UPBtn && banderaUp==1){
 banderaUp=0;
 }
 if(OKBtn && banderaOk==0){
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
 if(!DOWNBtn && banderaDown==1){
 banderaDown=0;
 }


 if(banderaOk == 1){
 if(opcion == 1){
 cnfTiempoLcd();

 initTMR0();


 ultimo = 5;
 while(cntUser < tope){
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"trabajando");
 Delay_ms(200);
 }


 lectura=1;
 while(lectura<=16){
 EEPROM_Write(0x00+lectura,lectura);
 lectura++;
 }

 EEPROM_Write(0x00,0x00+4);



 Lcd_Cmd(_LCD_CLEAR);
 Delay_ms(200);
 Lcd_Out(1,1,"muestreo");
 Delay_ms(50);
 Lcd_Out(2,1,"listo");
 Delay_ms(300);
 RB0_bit=0;
 RB1_bit=0;


 }else if(opcion == 2){
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
