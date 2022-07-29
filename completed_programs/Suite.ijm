
 //Goal, create a plugin that prompts user to select the tool that they want which will load in that macron 

//Welcome dialog
Dialog.create("Welcome"); 
	Dialog.addMessage("Select the program you wish to run on the analysis suite");
	Dialog.addMessage("Smash OK when done"); 
	analysis_types = newArray("None", "Asyn/TUJ1 Overlap Ganglia Only", 
	"Asyn/Tuj1 Overlap Visual Only", 
	"Macrophage/Tuj1 Contact Area Ganglia Only", 
	"Macrophage Area and Perimeter", 
	"Macrophage/Tuj1 Contact Area Total", 
	"Macrophage Nearest Neighbor macrophage2macrophage Distance", 
	"Macrophage Projection Area", 
	"MHCII/TUJ1/Asyn Nearest Neighbor Counts", 
	"filler" ); 
	Dialog.addChoice("Analysis" , analysis_types); 
Dialog.show();	
/////////

//get choice and load analysis 
choice = Dialog.getChoice();

if (choice == "None") {
	//selectWindow("Log");
	print("Done with Analysis!");
	exit }
else {};

if (choice == "Asyn/TUJ1 Overlap Ganglia Only") {
	runMacro("final_ganglia_only_asyn_tuj1_overlap");
}
else {};

if (choice == "Asyn/Tuj1 Overlap Visual Only") {
	runMacro("final_tuj1_asyn_overlap_visual_only");
}
else {};

if (choice == "Macrophage/Tuj1 Contact Area Ganglia Only") {
	runMacro("final_ganglia_only_macrophage_contact_area");
}
else {};

if (choice == "Macrophage Area and Perimeter") {
	runMacro("final_macrophage_area_and_perimeter");
}
else {};

if (choice == "Macrophage/Tuj1 Contact Area Total") {
	runMacro("final_macrophage_TUJ1_contact_area");
}
else {};

if (choice == "Macrophage Nearest Neighbor macrophage2macrophage Distance") {
	runMacro("final_nearest_neighbor_macrophage2macrophage_distances");
}
else {};

if (choice == "Macrophage Projection Area") {
	runMacro("Final_Projection_Area");
}
else {};
if (choice == "MHCII/TUJ1/Asyn Nearest Neighbor Counts") {
	runMacro("final_soma_positive_macrophage_neighbor_analysis");
}
else {};

if (choice == "filler") {
	runMacro("filler");
}
else {};
