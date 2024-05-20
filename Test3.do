vsim -gui work.processor_integration
add wave -position end  sim:/processor_integration/Clk
add wave -position end  sim:/processor_integration/Rst
add wave -position end  sim:/processor_integration/RESET
add wave -position end  sim:/processor_integration/INTERUPT
add wave -position end  sim:/processor_integration/In_Port
add wave -position end  sim:/processor_integration/Out_Port
add wave -position end  sim:/processor_integration/EXCEPTION
add wave -position end  sim:/processor_integration/Fetch_Stage_Instance/Program_Counter_Instance/pc_address
add wave -position end  /processor_integration/Decode_Stage_Instance/Register_File_Instance/registers
add wave -position end  /processor_integration/Memory_Stage_Instance/Memory_instance/ram
mem load -i C:/Users/Y.A/Desktop/finaltests/Memory.mem /processor_integration/Fetch_Stage_Instance/Instruction_Memory_Instance/ram
force -freeze sim:/processor_integration/Clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/processor_integration/Rst 1 0
run
force -freeze sim:/processor_integration/Rst 0 0
force -freeze sim:/processor_integration/RESET 1 0
force -freeze sim:/processor_integration/INTERUPT 0 0
force -freeze sim:/processor_integration/In_Port x\"00000005\" 0
run
force -freeze sim:/processor_integration/RESET 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run


