#line 1 "C:/Users/Dell/Desktop/TIPOS DE DATOS/ProyectoIntegrador/ProyectoIntegrador.c"

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

sbit UPBot at RC0_bit;
sbit OKBot at RC1_bit;
sbit DOWNBot at RC2_bit;

int banderaUp = 0;
int banderaOk = 0;
int banderaDown = 0;

char *txt;

void main() {
 ANSEL = 255;
 ANSELH = 0;
 TRISA = 0b00001101;
 TRISC = 0b10000111;
 PORTB = 0;
 UART1_Init(9600);
 Delay_ms(100);

 UART1_Write_Text("Start");
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"Proyecto Integr.");
 ADC_Init();
 while(1){
 if(UPBot && banderaUp==0){
 banderaUp = 1;
 txt = "MuestreoXtiempo";
 Lcd_Out(1,1,txt);
 Delay_ms(20);
 }
 if(!UPBot && banderaUp==1){
 banderaUp=0;
 }
 if(DOWNBot && banderaDown==0){
 banderaDown = 1;
 txt = "Mostrar muestras";
 Lcd_Out(1,1,txt);
 Delay_ms(20);
 }
 if(!DOWNBot && banderaDown==1){
 banderaDown=0;
 }
 }
}
