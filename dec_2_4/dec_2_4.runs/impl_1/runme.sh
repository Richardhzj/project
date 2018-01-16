#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/l/Xilinx_Vivado_SDK_2017.2_0616_1/SDK/2017.2/bin:/l/Xilinx_Vivado_SDK_2017.2_0616_1/Vivado/2017.2/ids_lite/ISE/bin/lin64:/l/Xilinx_Vivado_SDK_2017.2_0616_1/Vivado/2017.2/bin
else
  PATH=/l/Xilinx_Vivado_SDK_2017.2_0616_1/SDK/2017.2/bin:/l/Xilinx_Vivado_SDK_2017.2_0616_1/Vivado/2017.2/ids_lite/ISE/bin/lin64:/l/Xilinx_Vivado_SDK_2017.2_0616_1/Vivado/2017.2/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=/l/Xilinx_Vivado_SDK_2017.2_0616_1/Vivado/2017.2/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/l/Xilinx_Vivado_SDK_2017.2_0616_1/Vivado/2017.2/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/nfs/nfs7/home/huang238/dec_2_4/dec_2_4.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .write_bitstream.begin.rst
EAStep vivado -log dec_3_8.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source dec_3_8.tcl -notrace


