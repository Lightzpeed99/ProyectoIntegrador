#line 1 "C:/Users/Dell/Desktop/TIPOS DE DATOS/ProyectoIntegrador/nextion/nextion.c"
unsigned char trama[30];
char envia[30];
char valor[2];
char cuenta = 0;
char flag_rx = 0;
char dato = 0;
int i = 0;
#line 16 "C:/Users/Dell/Desktop/TIPOS DE DATOS/ProyectoIntegrador/nextion/nextion.c"
void manda_serial_const(const char *info){
 while(*info){
 UART1_Write(*info++);
 }
}



void interrupt(){
 if (RCIF_bit == 1){
 dato=RCREG;
 trama[cuenta] = dato;
 if ((cuenta > 3) && (trama[cuenta] == 0xff) && (trama[cuenta-1] == 0xff) && (trama[cuenta-2] == 0xff)){
 flag_rx = 1;
 CREN_bit = 0;
 INTCON.F7 = 0;
 }
 cuenta++;

 if (cuenta == 30){
 flag_rx = 0;
 cuenta = 0;
 }
 PIR1.F5 = 0;
 }
}


void procesa_Rx(){
 if (flag_rx==1){

 if ( strstr(trama,"DAC=")){

 }
 memset(trama,0,30);
 cuenta=0;
 flag_rx=0;
 PIR1.F5=0;
 CREN_bit=1;
 INTCON.F7=1;
 }
}
void mover_Graph(){
 for(i = 0; i<255; i++){
 sprinti(envia,"add 1,0,%d",i);
 UART1_Write_Text(envia);
 manda_serial_const("\xFF\xFF\xFF");
 }
}

void main() {
 ANSEL=0;
 ANSELH=0;

 PORTA=0;
 PORTD=0;
 PORTC=0;
 PORTB=0;
 PORTE=0;
 TRISA=0;
 TRISB=0;
 TRISD=0;
 TRISE=0;
 TRISC6_bit=0;
 TRISC7_bit=1;
 cuenta=0;
 UART1_Init(9600);
 memset(envia,0,30);

 PIR1.F5=0;
 PIE1.F5=1;
 INTCON.F6=1;
 INTCON.F7=1;
 while(1){

 mover_Graph();
 if(flag_rx){
 procesa_Rx();
 Delay_ms(1000);
 }
 }
}
