BEGIN{
FS=" "
run=1
rreq=0
RREQ_Packet_Size=0
Total_RREQ_Packet_Size=0
hello_message=0
H_M_Packet_Size=0
Total_H_M_Packet_Size=0
rrep=0
RREP_Packet_Size=0
Total_RREP_Packet_Size=0
rrep_ack=0
RREP_ACK_Packet_Size=0
Total_RREP_ACK_Packet_Size=0
rerr=0
t_rerr=0
RERR_Packet_Size=0
Total_RERR_Packet_Size=0
Routing_Overhead_S=0
Routing_Overhead_P=0
count_payload=0
t_packet=0
t_Packet_Size=0
t_Payload_Size=0
Total_t_Packet_Size=0
Total_t_Payload_Size=0
r_packet=0
r_Packet_Size=0
Total_r_Packet_Size=0
r_Payload_Size=0
Total_r_Payload_Size=0
last_packet_recive_time=0
pdr=0
total_hop_count=0
delay_count=0
total_delay=0
simulation_time=550;
base_ip="10.1.1."
broadcast_mac="ff:ff:ff:ff:ff:ff"
mac_add="00:00:00:00:00:"
first_packet_transmit_time=simulation_time

}
{

#for RREQ Packets Analysis


if ($1=="t" && $29==broadcast_mac && $81=="RREQ"){
	rreq++
	RREQ_Packet_Size=$66
	Total_RREQ_Packet_Size += RREQ_Packet_Size
}


#for Hello Packets Analysis

if ($1=="t" && $53=="1" && $81=="RREP" && $29==broadcast_mac && $87==$93){
	hello_message++
	H_M_Packet_Size=$66
	Total_H_M_Packet_Size += H_M_Packet_Size
}


#for RREP Packets Analysis



if ($1=="t" && $81=="RREP" && $87!=$93 && $31==mac_add(sprintf ("%02x",($4+1)))){
	rrep++
	RREP_Packet_Size=$66
	Total_RREP_Packet_Size += RREP_Packet_Size
}

#for RREP_ACK Packets Analysis

if ($1=="t" && $81=="RREP_ACK"){
	rrep_ack++
	RREP_ACK_Packet_Size=$66
	Total_RREP_ACK_Packet_Size += RREP_ACK_Packet_Size
}

#for RERR Packets Analysis

if ($1=="t" && $31==mac_add(sprintf ("%02x",($4+1))) && $81=="RERR" && $85=="Unreachable" && $86=="destination"){
	rerr++
	if ($22=="0" && $67==(base_ip$4+1)){
		t_rerr++
		RERR_Packet_Size=$66
		Total_RERR_Packet_Size += RERR_Packet_Size
	}	
}

#for Payload (data packets) Analysis

if ($1=="t" && $10=="Tx" && $79=="Payload" && $31==mac_add(sprintf ("%02x",($4+1)))){
	count_payload++;
	t_mac_retry[count_payload]=$22;
	unique_id_payload[count_payload]=$55"_"$67">"$69;

	if($22==0 && $67==(base_ip$4+1)){
		t_packet++;
		t_packet_node[t_packet]=$4
		t_Packet_Size=$66;
		t_Payload_Size=$82
		t_packet_id[t_packet]=$55;
		Total_t_Packet_Size +=t_Packet_Size;
		Total_t_Payload_Size +=t_Payload_Size;
		t_packet_time[t_packet]=$2;
		s_ip_t[t_packet]=$67;
		d_ip_t[t_packet]=$69;
		time_packet_a[$55]=$2;
		t_unique_id[t_packet]=$55"_"$67">"$69;
	}
}

if ($1=="r" && $11=="RxOk" && $69==(base_ip$5+1) && $79=="Payload" && $29==mac_add(sprintf ("%02x",($5+1)))){
	unique_receiver_id=$55"_"$67">"$69;
	if (NR==1 || !a[unique_receiver_id]++){
		r_packet++;
		r_Packet_Size=$66;
		r_Payload_Size=$82;
		Total_r_Payload_Size +=r_Payload_Size;
		Total_r_Packet_Size +=r_Packet_Size;
		r_packet_time[r_packet]=$2;
		d_ip_r[r_packet]=$69;
		s_ip_r[r_packet]=$67;
		r_packet_id[r_packet]=$55;
		r_unique_id[r_packet]=$55"_"$67">"$69;
		r_ttl_packet[r_packet]=$53

	}
}

if ($1=="t" && $2<first_packet_transmit_time && $10=="Tx" && $22==0 && $67==base_ip$4+1 && $79=="Payload"){
	first_packet_transmit_time=$2
}

if ($1=="r" && $11=="RxOk" && $29==mac_add(sprintf ("%02x",($5+1))) && $69==(base_ip$5+1) && $79=="Payload"){
	unique_receiver_id2=$55"_"$67">"$69;
	if (NR==1 || !b[unique_receiver_id2]++){
		if ($2>last_packet_recive_time)
			last_packet_recive_time=$2
	}
}

}
	
END{
Routing_Overhead_S = (Total_RREQ_Packet_Size + Total_RREP_Packet_Size + Total_H_M_Packet_Size + Total_RREP_ACK_Packet_Size + Total_RERR_Packet_Size)
Routing_Overhead_P = (rreq+rrep+rrep_ack+t_rerr+hello_message)
total_lost_packets=(t_packet - r_packet)

#for delay calculation
for(i=1; i<=r_packet; i++){
	for(j=1; j<=t_packet; j++){
		if (r_unique_id[i]==t_unique_id[j]){
			delay_count++
			delay[delay_count]=r_packet_time[i]-t_packet_time[j]
			total_delay +=delay[delay_count]
		}
	}
}

if (delay_count==r_packet && r_packet != 0)
	mean_delay=(total_delay/r_packet)
else
	printf "\nError 'Delay_count is not equal to no. of received packets'\n"


#analysis for hop count
for(k=1; k<=r_packet; k++){
	for(l=1; l<=count_payload; l++){
		if (r_unique_id[k]==unique_id_payload[l] && t_mac_retry[l]=="0"){
			hop_count_for_r_unique_id[k]++
		}
	}

	total_hop_count +=hop_count_for_r_unique_id[k]
}

printf ("data_for_run,"run"\n")
printf ("Tx_p,"t_packet"\n")
printf ("Rx_p,"r_packet"\n")
printf ("Tx_p_s,"Total_t_Packet_Size"\n")
printf ("Rx_p_s,"Total_r_Packet_Size"\n")
printf ("First_Tx_p_t,"first_packet_transmit_time"\n")
printf ("Last_Rx_p_t,"last_packet_recive_time"\n")
printf ("Mean_d,"mean_delay"\n")
printf ("Lost_p,"total_lost_packets"\n")
printf ("Lost_pkt_ratio,"((total_lost_packets * 100)/(r_packet+total_lost_packets))"\n")
printf ("Throughput,"(Total_r_Packet_Size*8/(last_packet_recive_time-first_packet_transmit_time))/1024"\n")
#printf ("Throughput,"(Total_r_Packet_Size*8/(simulation_time))/1000);
printf ("Goodput,"(Total_r_Payload_Size*8/(last_packet_recive_time-first_packet_transmit_time))/1024"\n")
#printf ("Goodput,"(Total_r_Payload_Size*8/(simulation_time))/1000"\n")
if (t_packet!=0){
printf ("PDR,"(r_packet*100)/t_packet"\n")
}
printf ("Routing_Overhead_Packets_By_AODV," Routing_Overhead_P"\n")
printf ("Routing_Overhead_Size_By_AODV," Routing_Overhead_S"\n")
if (r_packet!=0){
printf ("Average_Hop_Count,"total_hop_count/r_packet"\n")
printf ("Normalized_Routing_Load," Routing_Overhead_S/Total_r_Packet_Size"\n")
}
else{
printf ("Average_Hop_Count,"total_hop_count"\n")
printf ("Normalized_Routing_Load," Routing_Overhead_S"\n")
}
printf ("Route_Error_Overhead,"t_rerr"\n")
printf "\n"
}
