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
ExecStep $xv_path/bin/xsim sim_behav -key {Behavioral:sim_1:Functional:sim} -tclbatch sim.tcl -view /nfs/nfs7/home/huang238/mult_sw/sim_behav.wcfg -log simulate.log
