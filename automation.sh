#!/bin/bash
working_on_user_program_file=edit_$user_program_name_cp
#modify_tr_data_file_name=$tr_data_file_name-$name_according_x_axis-$k--$var_name-$l--run
modify_tr_data_file_name=$var_name-$l--$name_according_x_axis-$k--run

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
		echo  "*** " `date +"Date %F and Time (hh:mm:ss) %T"`" - Simulation execution start for run number : $iteration // $name_according_x_axis-$k // $var_name-$l ***"
		echo
		cd $ns3_path/ns-allinone-$ns3_version/ns-$ns3_version/scratch
		sed -e 's/SetRun(1)/SetRun('$iteration')/g' $working_on_user_program_file > $iteration.cc
		cd ..
		
		#./waf --run scratch/$iteration
		./ns3 run scratch/$iteration
				
		rm scratch/$iteration.cc
		mv $tr_data_file_name "$ns3_path"/$directory
		cd ~
		cd "$ns3_path"/$directory
		mv "$ns3_path"/$directory/$tr_data_file_name "$ns3_path"/$directory/$modify_tr_data_file_name-$iteration--$tr_data_file_name
		cp $modify_tr_data_file_name-$iteration--$tr_data_file_name "$ns3_path"/$directory/$tr_directory
		sed -i 's/\// /g' $modify_tr_data_file_name-$iteration--$tr_data_file_name
		sed -i 's/)/ )/g' $modify_tr_data_file_name-$iteration--$tr_data_file_name
		sed -i 's/(/( /g' $modify_tr_data_file_name-$iteration--$tr_data_file_name
		sed -i 's/=/ /g' $modify_tr_data_file_name-$iteration--$tr_data_file_name
		sed -i 's/,//g' $modify_tr_data_file_name-$iteration--$tr_data_file_name
		echo
		echo "*** Now, start metrics data computation for trace file name '$modify_tr_data_file_name-$iteration--$tr_data_file_name' ***"
		echo "#" `date` >>$modify_metrics_data_file_name
		sed -e 's/run=1/run='$iteration'/g' metrics_computation1.awk >metrics_computation1_$iteration.awk
		awk -f metrics_computation1_$iteration.awk $modify_tr_data_file_name-$iteration--$tr_data_file_name >>$modify_metrics_data_file_name
		echo "*** metrics data computation has been done and data has been stored in a file- '$modify_metrics_data_file_name' ***"
		echo
		rm metrics_computation1_$iteration.awk
		rm $modify_tr_data_file_name-$iteration--$tr_data_file_name
		cd ~
	done

cd "$ns3_path"/$directory || exit

#sed -i 's/-nan/'0'/g' $modify_metrics_data_file_name
echo
echo "*** Now, start statistics computation of data points = $run ***"
sed -i '/^rvalue/c rvalue='$ref_value'' statistics_computation.awk
awk -f statistics_computation.awk $modify_metrics_data_file_name >>$modify_statistics_data_file_name.csv
awk -f statistics_computation.awk $modify_metrics_data_file_name >>$modify_statistics_data_file_name
echo "*** statistics computation has been done and data has been stored in a file- '$modify_statistics_data_file_name' ***"
echo
cd ~
rm "$ns3_path"/ns-allinone-$ns3_version/ns-$ns3_version/scratch/$working_on_user_program_file
