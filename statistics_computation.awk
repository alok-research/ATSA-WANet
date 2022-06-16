BEGIN{
FS=","
rvalue=10
run=1
data_for_run_count=0
Tx_p_count=0
total_transmit_packets=0
mean_Tx_p=0
Rx_p_count=0
mean_Rx_p=0
Mean_d_count=0
Mean_delay=0
total_Mean_delay=0
Throughput_count=0
Throughput=0
total_Throughput=0
Goodput_count=0
Goodput=0
total_Goodput=0
PDR_count=0
packet_delivery_ratio=0
total_packet_delivery_ratio=0
RERR_O_count=0
RERR_Overhead=0
total_RERR_Overhead=0
mean_routeError_overhead=0
Lost_p_count=0
Lost_packet=0
total_Lost_packet=0
Lost_p_ratio_count=0
Lost_packet_ratio=0
Total_Lost_pkt_ratio=0
Hop_Count=0
Average_Hop_Count=0
total_Average_Hop_Count=0
add_Average_Hop_Count=0
ROH_packet_count=0
Routing_Overhead=0
total_Routing_Overhead=0
mean_routing_overhead=0

ROH_size_count=0
Routing_Overhead_size=0
total_Routing_Overhead_size=0

NRL_count=0
N_Routing_Overhead=0
total_N_Routing_Overhead=0
mean_normalized_routing_overhead=0


}
{
if($1=="data_for_run"){
	data_for_run_count++;
}

if($1=="Tx_p"){
	Tx_p_count++;
	transmit_packet=$2;
	total_transmit_packets +=transmit_packet;
	Tx_packet[Tx_p_count]=$2
}

if($1=="Rx_p"){
	Rx_p_count++;
	receive_packet=$2;
	total_receive_packets +=receive_packet;
	Rx_packet[Rx_p_count]=$2
}

if($1=="PDR"){
	PDR_count++;
	packet_delivery_ratio=$2;
	total_packet_delivery_ratio +=packet_delivery_ratio;
	pdr[PDR_count]=$2;
}

if($1=="Mean_d"){
	Mean_d_count++;
	Mean_delay=$2;
	total_Mean_delay +=Mean_delay;
	M_delay[Mean_d_count]=$2;
}

if($1=="Throughput"){
	Throughput_count++;
	Throughput=$2;
	total_Throughput +=Throughput;
	Through[Throughput_count]=$2;
}
     
if($1=="Goodput"){
	Goodput_count++;
	Goodput=$2;
	total_Goodput +=Goodput;
	Good[Goodput_count]=$2;
}

if($1=="Lost_p"){
	Lost_p_count++;
	Lost_packet=$2;
 	total_Lost_packet +=Lost_packet;
	Lost_pkt[Lost_p_count]=$2;
}

if($1=="Lost_pkt_ratio"){
	Lost_p_ratio_count++;
	Lost_packet_ratio=$2;
	total_Lost_pkt_ratio +=Lost_packet_ratio;
	Lost_p_ratio[Lost_p_ratio_count]=$2;
}


if($1=="Average_Hop_Count"){
	Hop_Count++;
	Average_Hop_Count=$2;
	total_Average_Hop_Count +=Average_Hop_Count;
	A_Hop_Count[Hop_Count]=$2;
}

if($1=="Routing_Overhead_Packets_By_AODV"){
	ROH_packet_count++;
	Routing_Overhead=$2;
	total_Routing_Overhead +=Routing_Overhead;
	roh[ROH_packet_count]=$2;
}

if($1=="Routing_Overhead_Size_By_AODV"){
	ROH_size_count++;
	Routing_Overhead_size=$2;
	total_Routing_Overhead_size +=Routing_Overhead_size;
	roh_size[ROH_size_count]=$2;
}
	
if($1=="Normalized_Routing_Load"){
	NRL_count++;
	N_Routing_Overhead=$2;
	total_N_Routing_Overhead +=N_Routing_Overhead;
	nroh[NRL_count]=$2;
}

if($1=="Route_Error_Overhead"){
	RERR_O_count++;
	RERR_Overhead=$2;
	total_RERR_Overhead +=RERR_Overhead;
	rerr_o[RERR_O_count]=$2;
}

}

END{
run=data_for_run_count;

if (run==Tx_p_count && run==Rx_p_count && run==Mean_d_count && run==Throughput_count && run==Goodput_count && run==PDR_count && run==RERR_O_count && run==Lost_p_count && run==Lost_p_ratio_count && run==Hop_Count && run==ROH_packet_count && run==ROH_size_count && run==NRL_count){

	mean_Tx_p=total_transmit_packets/run
	mean_Rx_p=total_receive_packets/run
	mean_pdr=total_packet_delivery_ratio/run;	
	mean_delay=total_Mean_delay/run;
	mean_throughput=total_Throughput/run;
	mean_goodput=total_Goodput/run;
	mean_lost_pkt=total_Lost_packet/run;
	mean_lost_pkt_ratio=total_Lost_pkt_ratio/run;
	mean_hop_count=total_Average_Hop_Count/run;
	mean_routing_overhead=total_Routing_Overhead/run;
	mean_routing_overhead_size=total_Routing_Overhead_size/run;
	mean_normalized_routing_overhead=total_N_Routing_Overhead/run;
	mean_routeError_overhead=total_RERR_Overhead/run;

	sq_n = sqrt(run);

	if(run>1){
		for(i=1; i<=run; i++){
			
			sub_Tx_p_i = Tx_packet[i] - mean_Tx_p
			sqaur_Tx_p_i = sub_Tx_p_i * sub_Tx_p_i
			add_Tx_p += sqaur_Tx_p_i
			standard_deviation_Tx_p = sqrt(add_Tx_p/(run-1));
			
			sub_Rx_p_i = Rx_packet[i] - mean_Rx_p
			sqaur_Rx_p_i = sub_Rx_p_i * sub_Rx_p_i
			add_Rx_p += sqaur_Rx_p_i
			standard_deviation_Rx_p = sqrt(add_Rx_p/(run-1));

			sub_pdr_i = pdr[i] - mean_pdr;
			squar_pdr_i = sub_pdr_i * sub_pdr_i;
			add_pdr += squar_pdr_i;
			standard_deviation_pdr = sqrt(add_pdr/(run-1));			
			
			sub_delay_i = M_delay[i] - mean_delay;
			squar_delay_i = sub_delay_i * sub_delay_i;
			add_delay += squar_delay_i;
			standard_deviation_delay = sqrt(add_delay/(run-1));			
			
			
			sub_throughput_i = Through[i] - mean_throughput;
			squar_throughput_i = sub_throughput_i * sub_throughput_i;
			add_throughput += squar_throughput_i;
			standard_deviation_throughput = sqrt(add_throughput/(run-1));
			
			sub_good_i = Good[i] - mean_goodput;
			squar_good_i=sub_good_i * sub_good_i;
			add_good +=squar_good_i;
			standard_deviation_good = sqrt(add_good/(run-1));
			#print "sub_good_"i " = "sub_good_i;
			#print "suar_good_"i" = "suar_good_i;
			#print "add_good = "add_good;

			sub_Lost_pkt_i = Lost_pkt[i] - mean_lost_pkt;
			squar_Lost_pkt_i = sub_Lost_pkt_i * sub_Lost_pkt_i;
			add_Lost_pkt += squar_Lost_pkt_i;
			standard_deviation_Lost_pkt = sqrt(add_Lost_pkt/(run-1));

			sub_Lost_pkt_ratio_i = Lost_p_ratio[i] - mean_lost_pkt_ratio;
			squar_Lost_pkt_ratio_i = sub_Lost_pkt_ratio_i * sub_Lost_pkt_ratio_i;
			add_Lost_pkt_ratio += squar_Lost_pkt_ratio_i;
			standard_deviation_Lost_pkt_ratio = sqrt(add_Lost_pkt_ratio/(run-1));

			sub_Average_Hop_Count_i = A_Hop_Count[i] - mean_hop_count;
			squar_Average_Hop_Count_i = sub_Average_Hop_Count_i * sub_Average_Hop_Count_i;
			add_Average_Hop_Count += squar_Average_Hop_Count_i;
			standard_deviation_Average_Hop_Count = sqrt(add_Average_Hop_Count/(run-1));

			sub_roh_i = roh[i] - mean_routing_overhead;
			squar_roh_i = sub_roh_i * sub_roh_i;
			add_roh += squar_roh_i;
			standard_deviation_roh = sqrt(add_roh/(run-1));

			sub_roh_size_i = roh_size[i] - mean_routing_overhead_size;
			squar_roh_size_i = sub_roh_size_i * sub_roh_size_i;
			add_roh_size += squar_roh_size_i;
			standard_deviation_roh_size = sqrt(add_roh_size/(run-1));

			sub_nroh_i = nroh[i] - mean_normalized_routing_overhead;
			squar_nroh_i = sub_nroh_i * sub_nroh_i;
			add_nroh += squar_nroh_i;
			standard_deviation_nroh = sqrt(add_nroh/(run-1));

			sub_RERR_i = rerr_o[i] - mean_routeError_overhead;
			squar_RERR_i = sub_RERR_i * sub_RERR_i;
			add_RERR += squar_RERR_i;
			standard_deviation_RERR = sqrt(add_RERR/(run-1));
		}

		printf rvalue"\t";
		printf mean_Tx_p"\t";
		printf mean_Rx_p"\t";
		printf mean_pdr"\t";
		printf mean_delay"\t";
		printf mean_throughput"\t";
		printf mean_goodput"\t";
		printf mean_lost_pkt"\t";
		printf mean_lost_pkt_ratio"\t";
		printf mean_hop_count"\t";
		printf mean_routing_overhead"\t";
		printf mean_routing_overhead_size"\t";
		printf mean_normalized_routing_overhead"\t";
		printf mean_routeError_overhead"\t";

		printf (standard_deviation_Tx_p * 1.960)/sq_n"\t";
		printf (standard_deviation_Rx_p * 1.960)/sq_n"\t";
		printf (standard_deviation_pdr * 1.960)/sq_n"\t";
		printf (standard_deviation_delay * 1.960)/sq_n"\t";
		printf (standard_deviation_throughput * 1.960)/sq_n"\t";
		printf (standard_deviation_good * 1.960)/sq_n"\t";
		printf (standard_deviation_Lost_pkt * 1.960)/sq_n"\t";
		printf (standard_deviation_Lost_pkt_ratio * 1.960)/sq_n"\t";
		printf (standard_deviation_Average_Hop_Count * 1.960)/sq_n"\t";
		printf (standard_deviation_roh  * 1.960)/sq_n"\t";
		printf (standard_deviation_roh_size * 1.960)/sq_n"\t";
		printf (standard_deviation_nroh  * 1.960)/sq_n"\t";
		printf (standard_deviation_RERR * 1.960)/sq_n"\t";
		printf "\n";

	}
	else{
		printf rvalue"\t";
		printf mean_Tx_p"\t";
		printf mean_Rx_p"\t";
		printf mean_pdr"\t";
		printf mean_delay"\t";
		printf mean_throughput"\t";
		printf mean_goodput"\t";
		printf mean_lost_pkt"\t";
		printf mean_lost_pkt_ratio"\t";
		printf mean_hop_count"\t";
		printf mean_routing_overhead"\t";
		printf mean_routing_overhead_size"\t";
		printf mean_normalized_routing_overhead"\t";
		printf mean_routeError_overhead"\t";
		printf "\n";

	}
}
else{
		printf rvalue"\t";
		printf total_transmit_packets"\t";
		printf total_receive_packets"\t";
		printf total_packet_delivery_ratio"\t";
		printf total_Mean_delay"\t";
		printf total_Throughput"\t";
		printf total_Goodput"\t";
		printf total_Lost_packet"\t";
		printf total_Lost_pkt_ratio"\t";
		printf total_Average_Hop_Count"\t";
		printf total_Routing_Overhead"\t";
		printf total_Routing_Overhead_size"\t";
		printf total_N_Routing_Overhead"\t";
		printf total_RERR_Overhead"\t";
		printf "\n";
}
}
