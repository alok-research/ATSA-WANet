# ATSA-WANet
An Automation Tool for Simulation Analysis of Wireless Ad Hoc Networks Using NS-3
Users are required to go through the following instructions

Note1: Keep all the files (param_dics_display.sh, config.sh, automation.sh, insert_line, metrics_computation.awk, statistics_computation.awk) in the same directory where NS-3 is installed. 

Note2: If an older version of NS-3 is being used (earlier to 3.36.1), the respective command at line number 32 of 'automation.sh' must be replaced with-
./waf --run scratch/userProgramName

Note3: First, use the following command to allow permission for all the bash scripts:
chmode +x config.sh automation.sh gnu_configure.sh

Phase-I
Step1: Open the script file name ‘param_disc_display.sh’
Step2: Provide NS-3 version (installed in user machine in which user wants to execute a program)
Step3: Provide the simulation experiment program file name coded in c++ e.g. in the present case it is titled wireless_adhoc_network.cc
Step4: Run the script ‘param_disc_display.sh’ as the following command:
./param_disc_display.sh

Outcomes: The List of parameters is displayed on the screen (Terminal)
Step5: Choose the set of parameters and their values.

Phase-II
Step1:  Open the configuration script. In the present case, it is titled ‘config.sh’.
Step2: Provide NS-3 version (installed in user machine in which user wants to execute a program),User Program Name, The number of iterations (run) etc.
Step3: Set the value of parameters chosen in phase-I
Step4: Run the script ‘config.sh’ as the following command:
./config.sh

Outcomes: All the trace files with respective iterations(runs) would be stored in the workspace/trace_files directory. Similarly following output files would be stored in the given directories
Metric data file in the workspace directory
Statistics data file in the workspace directory
Graphs related to PDR, Throughput, Goodput, Average End-to-End Delay, Normalized Routing Load etc. in the workspace/graphs directory
