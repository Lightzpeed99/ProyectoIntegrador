#line 1 "C:/Users/Dell/Desktop/TIPOS DE DATOS/ProyectoIntegrador/PI/PI.c"

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

short banderaUp = 0;
short banderaOk = 0;
short banderaDown = 0;

int opcion = 0;

int lect = 0;
unsigned int valor = 0;
unsigned long cnt = 0;
unsigned long cntUser = 0;
unsigned long tiempo = 0;
unsigned int segundos=0;
unsigned int minutos=0;
unsigned int horas=0;
short timing = 0;
short decena = 0;
short espacio = 0;


int i = 0;
unsigned long tope = 0;
int j = 0;
int desp = 0;

unsigned long Voltaje = 0;
unsigned long tlong = 0;
char ch;
int VoltInt = 0;


char txtLong[10];
char text[20];


void resetAll(){
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
void initTMR0(){
 OPTION_REG = 0x82;
 TMR0 = 6;
 INTCON = 0xA0;
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
 switch(opc){
 case 1:
 Lcd_Chr(1,13,decena+48);
 Lcd_Chr(1,14,48+valor);
 horas = decena*10+valor;
 break;
 case 2:
 Lcd_Chr(2,5,decena+48);
 Lcd_Chr(2,6,48+valor);
 minutos = decena*10+valor;
 break;
 case 3:
 Lcd_Chr(2,13,decena+48);
 Lcd_Chr(2,14,48+valor);
 segundos = decena*10+valor;
 break;
 }
 Delay_ms(100);
}

void cnfTiempoLcd(){
 timing = 1;
 desp = 0;
 Lcd_Cmd(_LCD_CLEAR);


 Lcd_Out(1,1,"Tiempo: ");
 Delay_ms(50);
 Lcd_Out(1,9,"Hrs[  ]");
 Delay_ms(50);
 Lcd_Out(2,1,"Min[  ]");
 Delay_ms(50);
 Lcd_Out(2,9,"Seg[  ]");
 Delay_ms(50);
 valor = 0;
 while(timing != 4){
 if(UPBtn && banderaUp==0){
 banderaUp = 1;
 valor++;
 procesarValor(timing);
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
 switch(timing){
 case 2:
 if(horas==0){
 Lcd_Chr(1,13,'0');
 Lcd_Chr(1,14,'0');
 }
 break;
 case 3:if(minutos == 0){
 Lcd_Chr(2,5,'0');
 Lcd_Chr(2,6,'0');
 }
 break;
 case 4:
 if(segundos == 0){
 Lcd_Chr(2,13,'0');
 Lcd_Chr(2,14,'0');
 }
 break;
 }
 }
 if(DOWNBtn && banderaDown==0){
 banderaDown = 1;
 valor--;
 procesarValor(timing);
 }
 if(!DOWNBtn && banderaDown==1){
 banderaDown=0;
 }
 }
 tope = horas*360+minutos*60+segundos;
}

void GuardarEEPROM(){
 i = EEPROM_Read(0)*4;




 tlong = (long)Voltaje * 5000;
 tlong = tlong / 1023;
 ch = tlong / 1000;

 Lcd_Chr(2,9,48+ch);
 EEPROM_Write(++i,ch);
 Delay_ms(20);
 Lcd_Chr_CP('.');
 ch = (tlong / 100) % 10;
 Lcd_Chr_CP(48+ch);
 EEPROM_Write(++i,ch);
 Delay_ms(20);
 ch = (tlong / 10) % 10;
 Lcd_Chr_CP(48+ch);
 EEPROM_Write(++i,ch);
 Delay_ms(20);
 ch = tlong % 10;
 Lcd_Chr_CP(48+ch);
 EEPROM_Write(++i,ch);
 Delay_ms(20);
 Lcd_Chr_CP('V');
 ch = EEPROM_Read(0);
 ch++;
 EEPROM_Write(0,ch);
 Delay_ms(2000);
}

void Muestrear(){


 RB0_bit = ~RB0_bit;
 LongToStr(Voltaje,text);
 UART1_Write_Text(text);
 UART1_Write_Text("\r\n");
 Voltaje+=ADC_Read(0);
}

void Mostrar(){



 Lcd_Out(1,1,"Mostrando data");
 delay_ms(300);
 tope = EEPROM_Read(0);
 UART1_Write_Text("\r\n");
 UART1_Write_Text("Tope:");
 LongToStr(tope,txtLong);
 UART1_Write_Text(txtLong);

 i = 0;
 j = 1;

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
 }else if(VoltInt==2){
 Delay_ms(50);
 Lcd_Chr(2,cnt,'.');
 j--;


 }else{
 i++;
 j--;
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
 if(cnt>1000){
 cntUser++;
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
 ANSEL = 255;
 ANSELH = 0;
 TRISA = 0b00001101;
 TRISC = 0b10000111;
 TRISB0_bit = 0;
 TRISB1_bit = 0;
 PORTB = 0;
 UART1_Init(9600);
 Delay_ms(100);
 UART1_Write_Text("Start");
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
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
 EEPROM_Write(0,0);
 while(1){

 if(UPBtn && banderaUp==0){
 banderaUp = 1;
 opcion = 1;

 Lcd_Out(2,1,"Sample by time");
 Delay_ms(500);
 }
 if(!UPBtn && banderaUp==1){
 banderaUp=0;
 }
 if(OKBtn && banderaOk==0){
 banderaOk = 1;
 }
 if(DOWNBtn && banderaDown==0){
 banderaDown = 1;
 opcion = 2;

 Lcd_Out(2,1,"View samples  ");
 Delay_ms(500);
 }
 if(!DOWNBtn && banderaDown==1){
 banderaDown=0;
 }
 if(banderaOk == 1){
 if(opcion == 1){
 cnfTiempoLcd();
 initTMR0();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,3,"Muestreando");
 Lcd_Out(2,7,"...");
 while(cntUser<tope){
 if(cnt==999){
 muestrear();
 }
 }
 UART1_Write_Text("\r\n");
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
 UART1_Write_Text("\r\n");
 GuardarEEPROM();
 Voltaje = 0;
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
