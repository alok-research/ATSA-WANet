#!/bin/bash
working_on_user_program_file=edit_$user_program_name_cp
modify_tr_data_file_name=$tr_data_file_name-$name_according_x_axis-$k--$var_name-$l--run
modify_metrics_data_file_name=$metrics_data_file_name-$name_according_x_axis-$k--$var_name-$l
ref_value=$k

cd "$ns3_path"/ns-allinone-$ns3_version/ns-$ns3_version/scratch || exit
cp $user_program_name_cp $working_on_user_program_file
cp "$ns3_path"/insert_line $ns3_path/ns-allinone-$ns3_version/ns-$ns3_version/scratch
sed -i '/SetSeed(/d' $working_on_user_program_file
sed -i '/SetRun(/d' $working_on_user_program_file
sed -i '/Time::SetResolution/d' $working_on_user_program_file
sed -i '/^[[:space:]]*$/d' $working_on_user_program_file
sed -i '/int main/{n;d}' $working_on_user_program_file
sed -i '/int main/r insert_line' $working_on_user_program_file
sed -i 's/.*Simulator::Stop.*/AsciiTraceHelper ascii_sem;\n&/' $working_on_user_program_file;
sed -i 's/.*Simulator::Stop.*/wifiPhy.EnableAsciiAll (ascii_sem.CreateFileStream ("'$tr_data_file_name'"));\n&/' $working_on_user_program_file;
rm insert_line
cd ~ || exit

for ((iteration=1; iteration<=$run; iteration++))					
	do
	
		echo											
		echo "*** Simulation is executing for run number : $iteration // $name_according_x_axis-$k // $var_name-$l ***"
		echo
		echo  `date +"Date %F and Execution Time start for this run (hh:mm:ss) %T"`
		echo
		cd $ns3_path/ns-allinone-$ns3_version/ns-$ns3_version/scratch
		sed -e 's/SetRun(1)/SetRun('$iteration')/g' $working_on_user_program_file > $iteration.cc
		cd ..
		./ns3 run scratch/$iteration		
		sleep 5
		sed -i 's/\// /g' $tr_data_file_name
		sed -i 's/)/ )/g' $tr_data_file_name
		sed -i 's/(/( /g' $tr_data_file_name
		sed -i 's/=/ /g' $tr_data_file_name
		sed -i 's/,//g' $tr_data_file_name
		#mv $tr_data_file_name $modify_tr_data_file_name-$iteration
		mv $tr_data_file_name "$ns3_path"/$directory
		mv "$ns3_path"/$directory/$tr_data_file_name "$ns3_path"/$directory/$modify_tr_data_file_name-$iteration
		rm scratch/$iteration.cc
			
	done
#rm scratch/$working_on_user_program_file
cd ~ || exit
cd "$ns3_path"/$directory || exit

# ******Start *******for configure in gnu configure file
#echo "count = $n_count"
sed -i '/count=/d' gnu_configure.sh
sed -i 's/.*plot.*/count='$n_count'\n&/' gnu_configure.sh
sed -i '/j_value_start=/d' gnu_configure.sh
sed -i 's/.*plot.*/j_value_start='$var_value_first'\n&/' gnu_configure.sh
sed -i '/j_value_diff=/d' gnu_configure.sh
sed -i 's/.*plot.*/j_value_diff='$var_value_diff'\n&/' gnu_configure.sh


sed -i '/x_min=/d' gnu_configure.sh
sed -i '/x_max=/d' gnu_configure.sh
sed -i '/x_delta=/d' gnu_configure.sh
sed -i 's/.*x_minimum.*/x_min='$x_min'\n&/' gnu_configure.sh
sed -i 's/.*x_minimum.*/x_max='$x_max'\n&/' gnu_configure.sh
sed -i 's/.*x_minimum.*/x_delta='$x_delta'\n&/' gnu_configure.sh
#*********End**********

echo "#" `date` >$metrics_data_file_name
	for ((b=1; b<=$run; b++))					
	do
		sed -e 's/run=1/run='$b'/g' metrics_computation1.awk >metrics_computation1_$b.awk
		awk -f metrics_computation1_$b.awk $modify_tr_data_file_name-$b >>$metrics_data_file_name
		rm metrics_computation1_$b.awk
		mv $modify_tr_data_file_name-$b "$ns3_path"/$directory/$tr_directory
	done
mv $metrics_data_file_name $modify_metrics_data_file_name
#sed -i 's/-nan/'0'/g' $modify_metrics_data_file_name

sed -i '/^rvalue/c rvalue='$ref_value'' statistics_computation.awk
awk -f statistics_computation.awk $modify_metrics_data_file_name >>$modify_statistics_data_file_name.csv
awk -f statistics_computation.awk $modify_metrics_data_file_name >>$modify_statistics_data_file_name

#echo
cd ~
rm "$ns3_path"/ns-allinone-$ns3_version/ns-$ns3_version/scratch/$working_on_user_program_file
echo 'Done!'
#nautilus $directory

