/*
 Name: Jun Wang(wang314)
 Partner: Chenyang Li
*/



#include <stm32f30x.h> // Pull in include files for F30x standard drivers
#include <f3d_uart.h>
#include <f3d_user_btn.h>
#include <f3d_lcd_sd.h>
#include <f3d_i2c.h>
#include <f3d_accel.h>
#include <f3d_mag.h>
#include <f3d_delay.h>
#include <f3d_nunchuk.h>
#include <f3d_led.h>
#include <f3d_gyro.h>
#include <math.h>
#include <stdio.h>
#define TIMER 20000


int main(void) {
  // Set up your inits before you go ahead
  f3d_uart_init();
  delay(10);
  f3d_delay_init();
  f3d_i2c1_init();
  delay(10);
  f3d_accel_init();
  delay(10);
  f3d_mag_init();
  delay(10);
  f3d_user_btn_init();
  delay(10);
  f3d_led_init();
  delay(10);
  f3d_lcd_init();
  delay(10);
  f3d_nunchuk_init(); // new_added
  delay(10);
  f3d_gyro_init();

  setvbuf(stdin, NULL, _IONBF, 0);
  setvbuf(stdout, NULL, _IONBF, 0);
  setvbuf(stderr, NULL, _IONBF, 0);

  f3d_lcd_fillScreen(RED);
  f3d_led_all_off();

  // initializations for variables
  int temp = 1;
  nunchuk_t data;
  int pre_temp = 0;
  
  while(1){
    f3d_nunchuk_read(&data);
    delay(100);
    if( data.jx >= 250 || data.z == 1) { 
      temp = (temp + 1) % 4;
    }
    
    if( data.jx <= 5 || data.c == 1) {
      temp = (temp + 3) % 4;
    }
    printf("%d\n", temp);
    
     if(temp != pre_temp) 
       f3d_lcd_fillScreen(RED); 

    // switch the screen
    switch(temp) {
    case 0: 
      printf("Nunchuk \n");
      f3d_nunchuk_screen();
      break;
      
    case 1:
      printf("gyro \n");
      f3d_gyro_screen();
      break;
      
    case 2:
      printf("accel \n");
      f3d_accel_screen();
      break;
      
    case 3:
      printf("compass \n");
      f3d_led_all_off();
      f3d_mag_screen();
      break;
    }
    pre_temp = temp;
  }
    
}

    
   
    
    
 
 
#ifdef USE_FULL_ASSERT
 void assert_failed(uint8_t* file, uint32_t line) {
   /* Infinite loop */
   /* Use GDB to find out why we're here */
   while (1);
 }


#endif
