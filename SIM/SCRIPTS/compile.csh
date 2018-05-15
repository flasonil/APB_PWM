rm -rf work
vlib work

vlog -sv -work work -quiet RTL/APB_PWM.sv

vlog -sv -work work -quiet RTL/PWM.sv

vlog -sv -work work -quiet TB/tb_APB_PWM.sv
