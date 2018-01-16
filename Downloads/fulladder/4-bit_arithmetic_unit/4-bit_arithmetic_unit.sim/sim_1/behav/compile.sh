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
echo "xvlog -m64 --relax -prj tb_alu_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj tb_alu_vlog.prj 2>&1 | tee compile.log
