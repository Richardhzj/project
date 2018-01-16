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
ExecStep $xv_path/bin/xsim tb_4_bit_logic_unit_behav -key {Behavioral:sim_1:Functional:tb_4_bit_logic_unit} -tclbatch tb_4_bit_logic_unit.tcl -log simulate.log
