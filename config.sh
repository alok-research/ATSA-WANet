#!/bin/bash
path=$(pwd)
ns3_path=$path

### NS-3 version, source file name, trace file name, number of iterations change *** 1/3 ***
# In case of lower version of NS3(< 3.36), replace the program execution command in automation.sh line number 32 as ./waf --run scrach/$iteration  

ns3_version=3.36.1		#change the installed ns3 version as in your system in which user wants to execute program

user_program_name=wireless_adhoc_network.cc	# change program name which you want to execute. It must be put in scrach directory of ns-3

tr_data_file_name=wireless_adhoc.tr	# ASCII Trace file name 

run=10			        # change no. of iteration as per requred


### Finish Configuration of *** 1/3 ***


###Configurion *** 2/3 ***
simulation_stop_time=10		# Simulation time

network_base_ip=10.1.1.		#value of first three octed with decimal point as used in source program

gx_axis_name="Simulation Time (sec)"  # X-Axis name for displaying in the graphs

name_according_x_axis=simulation_time	# name_according_x_axis using without space for first line of comments in output statistics file

### Finish Configuration of *** 2/3 ***


###### Name of the directories and output files #######

metrics_data_file_name=metric_data_file      # Name of file for metrics data generated by metrics_computation.awk
user_program_name_cp=cp_$user_program_name
statistics_data_file_name=statistics_data_file			# Name of file for statistics data generated by statistics_computation.awk

directory=workspace						# Name of directory for store all the files,data,graphs 

tr_directory=trace_files					# Name of directory for store trace files

graph_directory=graphs						# Name of directory for store graphs



cd "$ns3_path"/ns-allinone-$ns3_version/ns-$ns3_version/scratch 

if [ -f "$user_program_name" ]
	then
		echo "source file exit"
	else
		echo "source file not exit" && exit
fi

cd ~

  
if [ -d "$ns3_path"/$directory ]
	then
   		echo "$directory Directory exist"
	else
   		mkdir "$ns3_path"/$directory
fi

if [ -d "$ns3_path"/$directory/$tr_directory ]
	then
   		echo "$tr_directory Directory exist"
 	else
   	mkdir "$ns3_path"/$directory/$tr_directory
fi 

if [ -d "$ns3_path"/$directory/$graph_directory ]
	then
   		echo "$graph_directory Directory exist"
	else
   		mkdir "$ns3_path"/$directory/$graph_directory
fi

cp "$ns3_path"/metrics_computation.awk "$ns3_path"/$directory || exit
cp "$ns3_path"/statistics_computation.awk "$ns3_path"/$directory || exit
cp "$ns3_path"/gnu_configure.sh "$ns3_path"/$directory || exit

#echo "#" `date` >$metrics_data_file_name
export statistics_data_file_name
export name_according_x_axis
export var_name
export metrics_data_file_name
export payload
export simulation_stop_time
export tr_data_file_name
export ns3_path
export ns3_version
export run
export user_program_name
export user_program_name_cp
export directory
export tr_directory
export network_base_ip
cd ~ || exit
cd "$ns3_path"/ns-allinone-$ns3_version/ns-$ns3_version/scratch || exit
cp $user_program_name $user_program_name_cp
#sed -i '/uint32_t stop_time/d' $user_program_name_cp
#sed -i 's/.*CommandLine.*/uint32_t stop_time='$simulation_stop_time';\n&/' $user_program_name_cp;
cd ~ || exit

cd "$ns3_path"/$directory || exit
### Configure Parameters Display at Terminal as provided by user*** 3/3 ***
n_count=0       
var_name=ART	# Change here variable name which will be display inside graphs. In present case it is RRR(Routr Request Retries).
var_value_first=1   # set thefirst  value of parameter
var_value_last=3	#set the last value of parameter
var_value_diff=1	# set difference value between two value
for l in {1..3..1} 					# Change here value of variable as above
	do
	cd $ns3_path/ns-allinone-$ns3_version/ns-$ns3_version/scratch
	
	sed -i '/aodv.Set/d' $user_program_name_cp
	sed -i 's/.*InternetStackHelper.*/aodv.Set("ActiveRouteTimeout",TimeValue (Seconds ('$l')));\n&/' $user_program_name_cp
		
	#n_count=$((n_count+1))
	n_count=$l

	cd ~
# *** dont change here- start
	cd $ns3_path/$directory
	modify_statistics_data_file_name=$statistics_data_file_name--$var_name-$l
	#sed -i '1s/^/File Name \n/' $statistics_data_file_name--$var_name-$l
	echo "# `date`  (statistical Analysis of $run iteration) $var_name-$l" >$modify_statistics_data_file_name
	echo -e "#$name_according_x_axis,tTx_Packet,tRx_Packet,tavg_pdr,tavg_delay,tavg_throughput,tavg_goodput,tavg_lost_packets,tavg_lost_pkt_ratio,tavg_hop_count,tavg_routing_overhead_packet_by_AODV,tavg_routing_overhead_size_by_AODV,tavg_normalized_routing_load,tavg_N_RERR_Overhead,tci_at95%_Tx_p,tci_at95%_Rx_p,tci_at95%_pdr,tci_at95%_delay,tci_at95%_throughput,tci_at95%_goodput,tci_at95%_lost_pkt,tci_at95%_lost_ratio,tci_at95%_hop_count,tci_at95%_routing_overhead_packet,tci_at95%_routing_overhead_size,tci_at95%_NRO,tci_at95%_N_RERR_Overhead">>$modify_statistics_data_file_name

	echo "" >$modify_statistics_data_file_name.csv
	echo  "#" `date` ",(statistical Analysis of "$run" iteration) $var_name-$l">$modify_statistics_data_file_name.csv
	echo -e "#$name_according_x_axis,tTx_Packet,tRx_Packet,tavg_pdr,tavg_delay,tavg_throughput,tavg_goodput,tavg_lost_packets,tavg_lost_pkt_ratio,tavg_hop_count,tavg_routing_overhead_packet_by_AODV,tavg_routing_overhead_size_by_AODV,tavg_normalized_routing_load,tavg_N_RERR_Overhead,tci_at95%_Tx_p,tci_at95%_Rx_p,tci_at95%_pdr,tci_at95%_delay,tci_at95%_throughput,tci_at95%_goodput,tci_at95%_lost_pkt,tci_at95%_lost_ratio,tci_at95%_hop_count,tci_at95%_routing_overhead_packet,tci_at95%_routing_overhead_size,tci_at95%_NRO,tci_at95%_N_RERR_Overhead">>$modify_statistics_data_file_name.csv

	export modify_statistics_data_file_name var_value_first var_value_last var_value_diff
	cd ~
#** dont change here- end

#*** Start 'for loop' for configure values of x-axis variable as Simulation Time here

	x_min=10
	x_max=60
	x_delta=10
	for k in 10 20 30 40 50 60  	 # for x-axis
		do
		cd "$ns3_path"/ns-allinone-$ns3_version/ns-$ns3_version/scratch
		sed -i '/uint32_t stop_time=/d' $user_program_name_cp
		sed -i 's/.*CommandLine.*/uint32_t stop_time='$k';\n&/' $user_program_name_cp
		cd ~
		cd "$ns3_path"/$directory
		sed -e 's/base_ip="10.1.1."/base_ip="'$network_base_ip'"/g' metrics_computation.awk > metrics_computation1.awk
		cd ~
 		cd "$ns3_path"
		export k l n_count x_min x_max x_delta
		./automation.sh
		done
		cd $ns3_path/$directory 
		#mail -s "Regarding Final Data('$var_name' = '$l') for a manuscript" alokjk15@gmail.com < mail_TextBody -A $modify_statistics_data_file_name 
		cd "$ns3_path"
	done
rm $ns3_path/$directory/metrics_computation1.awk
rm "$ns3_path"/ns-allinone-$ns3_version/ns-$ns3_version/scratch/$user_program_name_cp

### Finish Configuration of *** 3/3 ***


cp "$ns3_path"/ns-allinone-$ns3_version/ns-$ns3_version/scratch/$user_program_name "$ns3_path"/$directory
cp "$ns3_path"/param_dics_display.sh "$ns3_path"/$directory
cp "$ns3_path"/config.sh "$ns3_path"/$directory
cp "$ns3_path"/automation.sh "$ns3_path"/$directory

cd "$ns3_path"/$directory

# For Plotting...

#script_name	graph_name($1)	x-axis_name($2)	y-axis_name($3)	coloumn_selection($4 & $5) Statistics_file_name($6) Variable name($7)		
./gnu_configure.sh "Tx_Packet" "$gx_axis_name" "Total Data Packets generated by sources" '1:2' '1:2:15'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "Rx_Packet" "$gx_axis_name" "Successful Delivered Packets" '1:3' '1:3:16'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "pdr" "$gx_axis_name" "Packet Delivery Ratio (%)" '1:4' '1:4:17'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "delay" "$gx_axis_name" "Average End-to-End Delay (sec)" '1:5' '1:5:18'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "throughput" "$gx_axis_name" "Throughput (Kibps)" '1:6' '1:6:19'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "goodput" "$gx_axis_name" "Goodput (Kibps)" '1:7' '1:7:20'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "lost_packets" "$gx_axis_name" "Lost Packets" '1:8' '1:8:21'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "lost_packet_ratio" "$gx_axis_name" "Lost Packets Ratio" '1:9' '1:9:22'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "Average_hop_count" "$gx_axis_name" "Average Hop Count" '1:10' '1:10:23'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "Routing_Overhead_p" "$gx_axis_name" "Routing Overhead" '1:11' '1:11:24'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "Routing_Overhead_s" "$gx_axis_name" "Routing Overhead (bytes)" '1:12' '1:12:25'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "N_Routing_Overhead" "$gx_axis_name" "Normalized Routing Load" '1:13' '1:13:26'	"$statistics_data_file_name--$var_name-"	"$var_name = "
./gnu_configure.sh "RERR_overhead" "$gx_axis_name" "Route Error Overload" '1:14' '1:14:27'	"$statistics_data_file_name--$var_name-"	"$var_name = "

mv "$ns3_path"/$directory/*.png "$ns3_path"/$directory/graphs
# BindUp Phase

cd ~	
#nautilus "$ns3_path"/$graph_directory
