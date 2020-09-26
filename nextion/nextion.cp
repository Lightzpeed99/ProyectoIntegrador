#line 1 "C:/Users/Dell/Desktop/TIPOS DE DATOS/ProyectoIntegrador/nextion/nextion.c"
sbit UPBtn at RC0_bit;
sbit OKBtn at RC1_bit;
sbit DOWNBtn at RC2_bit;

signed char trama[30];
char envia[30];
char valor[2];
char cuenta = 0;
char flag_rx = 0;
char dato = 0;
int i = 0;
int flag_mv = 0;
int flag_end = 0;
int der = 0;
int a = 0;


short banderaUp = 0;
short banderaOk = 0;
short banderaDown = 0;

int opcion = 0;


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


int tope = 0;
int j = 0;
int desp = 0;

unsigned long Voltaje = 0;
unsigned long tlong = 0;
char ch;
int VoltInt = 0;


char txtLong[10];
char text[3];

void resetAll(){
 cuenta = 0;
 flag_rx = 0;
 dato = 0;
 i = 0;
 flag_mv = 0;
 flag_end = 0;
 der = 0;
 a = 0;

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

void initTMR0(){
 OPTION_REG = 0x82;
 TMR0 = 6;
 INTCON = 0xA0;
}

void manda_serial_const(const char *info){
 while(*info){
 UART1_Write(*info++);
 }
}



void interrupt(){
 if (RCIF_bit == 1){
 dato=RCREG;
 trama[cuenta] = dato;
 if ((cuenta > 3) && ((unsigned char)trama[cuenta] == 0xff) && ((unsigned char)trama[cuenta-1] == 0xff) && ((unsigned char)trama[cuenta-2] == 0xff)){
 flag_rx = 1;
 CREN_bit = 0;
 INTCON.F7 = 0;
 }
 cuenta++;

 if (cuenta == 30){
 flag_rx = 0;
 cuenta = 0;
 flag_mv = 0;
 }
 PIR1.F5 = 0;
 }
 if (TMR0IF_bit){
 flag_mv = 1;
 cnt++;
 TMR0IF_bit = 0;
 TMR0 = 6;
 if(cnt == 1000){
 cntUser++;
 cnt = 0;
 }
 if(cntUser == tope){
 flag_end = 1;
 OPTION_REG = 0x00;
 TMR0 = 0;
 INTCON = 0x00;
 }
 }
}


void procesa_Rx(){
 if (flag_rx == 1){

 if (strstr(trama,"t=")){
 flag_mv = 1;
 tope = atoi(trama[2]<<16)+atoi(trama[3]<<8)+atoi(trama[4]);
 }
 if(strstr(trama,"b=")){
 der = atoi(trama[2]);
 }
 memset(trama,0,30);
 cuenta = 0;
 flag_rx = 0;
 PIR1.F5 = 0;
 CREN_bit = 1;
 INTCON.F7 = 1;
 }
}

void mover_Graph(){



 lect = ADC_Read(0);
 i = (unsigned int)(lect*255)/1023;
 sprinti(envia,"add 8,0,");
 UART1_Write_Text(envia);
 sprinti(envia,"%d",i);
 UART1_Write_Text(envia);
 manda_serial_const("\xFF\xFF\xFF");
 Voltaje+=i;



}

void Mostrar(){
 tope = EEPROM_Read(0);
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
 sprinti(envia,"ViewSamples.text0.txt=\"");
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
 tlong = (long)Voltaje * 5000;
 tlong = tlong / 1023;
 ch = tlong / 1000;

 EEPROM_Write(++i,ch);
 Delay_ms(20);
 ch = (tlong / 100) % 10;
 EEPROM_Write(++i,ch);
 Delay_ms(20);
 ch = (tlong / 10) % 10;
 EEPROM_Write(++i,ch);
 Delay_ms(20);
 ch = tlong % 10;
 EEPROM_Write(++i,ch);
 Delay_ms(20);
 ch = EEPROM_Read(0);
 ch++;
 EEPROM_Write(0,ch);
 Voltaje = 0;
}

void main(){
 ANSEL = 255;
 ANSELH = 0;
 TRISA = 0b00001101;
 TRISB = 0;
 TRISC = 0b10000000;
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
