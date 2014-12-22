
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name graduate_rc_car -dir "C:/Users/jjshawver/Documents/DHD/RTL/graduate_rc_car/planAhead_run_2" -part xc3s100ecp132-5
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "rc_car_top.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {uart.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Pwm.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {rc_car_top.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top rc_car_top $srcset
add_files [list {rc_car_top.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s100ecp132-5
