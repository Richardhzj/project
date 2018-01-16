/* f3d_systick.c --- 
 * name : JUN WANG  Samuel Eleftheri - selefthe
 * Filename: f3d_systick.c
 * Description: 
 * Author: Bryce Himebaugh
 * Maintainer: 
 * Created: Thu Nov 14 07:57:37 2013
 * Last-Updated: 
 *           By: 
 *     Update #: 0
 * Keywords: 
 * Compatibility: 
 * 
 */

/* Commentary: 
 * 
 * 
 * 
 */

/* Change log:
 * 
 * 
 */

/* Copyright (c) 2004-2007 The Trustees of Indiana University and 
 * Indiana University Research and Technology Corporation.  
 * 
 * All rights reserved. 
 *
 * Additional copyrights may follow 
 */

/* Code: */

#include <f3d_systick.h>
#include <f3d_led.h> 
#include <f3d_user_btn.h>
#include <f3d_uart.h>
#include <queue.h>

volatile int systick_flag = 0; 
struct queue txbuf; // uart queue
static int light = -1;

// Setup Initial Rate Of Timer
void f3d_systick_init(void) {
  SysTick_Config(SystemCoreClock/SYSTICK_INT_SEC);
}

void SysTick_Handler(void) {
  if (user_btn_read()) {
    SysTick_Config(SystemCoreClock/10);
  }
  else {
    SysTick_Config(SystemCoreClock/100); 
  }

  f3d_led_off(light); // current light off
  light = (light + 1) % 8; // update light
  f3d_led_on(light); // turn on light
 
  if (!queue_empty(&txbuf)) { 
    flush_uart(); // gotta create this in your uart!
  }
}


/* f3d_systick.c ends here */
