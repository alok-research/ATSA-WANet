#include "ns3/core-module.h"
#include "ns3/config-store-module.h"
#include "ns3/mobility-module.h"
#include "ns3/wifi-module.h"
#include "ns3/aodv-module.h"
#include "ns3/netanim-module.h"
#include "ns3/internet-module.h"
#include "ns3/position-allocator.h"
#include "ns3/applications-module.h"
#include "ns3/network-module.h"

using namespace ns3;

NS_LOG_COMPONENT_DEFINE ("WirelessAdhocNet");

int main(int argc, char *argv[])
{

RngSeedManager::SetSeed(1);  
RngSeedManager::SetRun(1);

uint32_t totalNodes=3;
std::string phyMode ("DsssRate1Mbps");

uint32_t stop_time=10;	// pv_atsa varies from 10 to 60
CommandLine cmd;
cmd.Parse (argc, argv);

Config::SetDefault ("ns3::WifiRemoteStationManager::NonUnicastMode",StringValue ("DsssRate1Mbps"));
Config::SetDefault ("ns3::WifiRemoteStationManager::RtsCtsThreshold", UintegerValue (1)); // enable rts cts.


NodeContainer adhoc_nodes;		
adhoc_nodes.Create (totalNodes);

NodeContainer adhoc_staNodes;
NodeContainer adhoc_mobileNodes;

adhoc_staNodes.Add(adhoc_nodes.Get(0));
adhoc_mobileNodes.Add(adhoc_nodes.Get(1)); //node 2 is mobile node
adhoc_staNodes.Add(adhoc_nodes.Get(2));

WifiHelper wifi;
wifi.SetStandard (WIFI_STANDARD_80211b);

WifiMacHelper wifiMac;
wifiMac.SetType ("ns3::AdhocWifiMac");

wifi.SetRemoteStationManager( "ns3::ConstantRateWifiManager",
                                "DataMode", StringValue ("DsssRate1Mbps"),
                                "ControlMode", StringValue ("DsssRate1Mbps"));


  YansWifiPhyHelper wifiPhy;
  YansWifiChannelHelper wifiChannel;
  wifiChannel.SetPropagationDelay ("ns3::ConstantSpeedPropagationDelayModel");
  wifiChannel.AddPropagationLoss ("ns3::LogDistancePropagationLossModel",
					"Exponent", DoubleValue (3.0),
					"ReferenceLoss", DoubleValue (40.0459));

					
  wifiPhy.SetChannel (wifiChannel.Create ());

  NetDeviceContainer adhocDevices = wifi.Install (wifiPhy, wifiMac, adhoc_nodes);

  MobilityHelper mobility_forStaNodes, mobility_forMobileNode;
  
  Ptr<ListPositionAllocator> positionAlloc = CreateObject<ListPositionAllocator> ();
  positionAlloc->Add (Vector (0.0, 60.0, 0.0));
  positionAlloc->Add (Vector (140.0, 60.0, 0.0));
  //positionAlloc->Add (Vector (210.0, 60.0, 0.0));
  mobility_forStaNodes.SetPositionAllocator (positionAlloc);
  mobility_forStaNodes.SetMobilityModel ("ns3::ConstantPositionMobilityModel");
  mobility_forStaNodes.Install (adhoc_staNodes);
 
//Assign mobility model for node 1
 mobility_forMobileNode.SetMobilityModel ("ns3::SteadyStateRandomWaypointMobilityModel",
"MinSpeed", DoubleValue (20),
"MaxSpeed", DoubleValue (20),
"MinPause", DoubleValue (0),
"MaxPause", DoubleValue (0),
								"MinX", DoubleValue (50),
								"MaxX", DoubleValue (90),
								"MinY", DoubleValue (20),
								"MaxY", DoubleValue (40));

  mobility_forMobileNode.Install (adhoc_mobileNodes);


  
AodvHelper aodv;
aodv.Set("ActiveRouteTimeout",TimeValue (Seconds (1)));	// pv_atsa varies value of ART from 1 to 3
  InternetStackHelper stack;
  
  stack.SetRoutingHelper (aodv);
  stack.Install (adhoc_nodes);

  Ipv4AddressHelper address;
  address.SetBase ("10.1.1.0", "255.255.255.0");

  Ipv4InterfaceContainer interfaces;
  interfaces = address.Assign (adhocDevices);
	
  ApplicationContainer cbrApps;
  uint16_t cbrPort = 12345;
  OnOffHelper OnOffApp ("ns3::UdpSocketFactory", InetSocketAddress (Ipv4Address ("10.1.1.3"), cbrPort));
  OnOffApp.SetAttribute ("PacketSize", UintegerValue (512));
  OnOffApp.SetAttribute ("OnTime",  StringValue ("ns3::ConstantRandomVariable[Constant=1.0]"));
  OnOffApp.SetAttribute ("OffTime", StringValue ("ns3::ConstantRandomVariable[Constant=0.0]"));
  OnOffApp.SetAttribute ("DataRate", StringValue ("4Kib/s"));
  OnOffApp.SetAttribute ("StopTime", TimeValue (Seconds (stop_time)));
  cbrApps.Add (OnOffApp.Install (adhoc_nodes.Get (0))); 


AnimationInterface anim ("wireless_adhoc.xml");

AsciiTraceHelper ascii;
wifiPhy.EnableAsciiAll (ascii.CreateFileStream ("wireless_adhoc.tr"));

Simulator::Stop(Seconds(stop_time));		
Simulator::Run();
Simulator::Destroy();	
return 0;
}



