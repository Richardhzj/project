# 
# Synthesis run script generated by Vivado
# 

create_project -in_memory -part xc7a35ticpg236-1L

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /nfs/nfs7/home/huang238/Lab8/Lab8.cache/wt [current_project]
set_property parent.project_path /nfs/nfs7/home/huang238/Lab8/Lab8.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo /nfs/nfs7/home/huang238/Lab8/Lab8.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib /nfs/nfs7/home/huang238/Lab8/Lab8.srcs/sources_1/new/main.v
# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc /nfs/nfs7/home/huang238/Lab8/Lab8.srcs/constrs_1/new/main.xdc
set_property used_in_implementation false [get_files /nfs/nfs7/home/huang238/Lab8/Lab8.srcs/constrs_1/new/main.xdc]


synth_design -top display -part xc7a35ticpg236-1L


write_checkpoint -force -noxdef display.dcp

catch { report_utilization -file display_utilization_synth.rpt -pb display_utilization_synth.pb }
