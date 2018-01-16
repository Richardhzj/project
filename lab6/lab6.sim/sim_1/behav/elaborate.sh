#!/bin/bash -f
xv_path="/l/Xilinx_Vivado_SDK_2017.2_0616_1/Vivado/2017.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto 19741316388c4b7e97ab778f070d9dca -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_fa4_behav xil_defaultlib.tb_fa4 xil_defaultlib.glbl -log elaborate.log
