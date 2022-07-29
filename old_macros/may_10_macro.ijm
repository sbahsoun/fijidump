
//condensed version of code 

//welcome prompt
Dialog.create("Macrophage Analysis (Again)");
	Dialog.addMessage("Macrophage/Soma Analysis");
	//Dialog.addMessage("Type: Macrophage analysis as a fn of distance to soma");
	Dialog.addMessage("Ready to Continue?");
	Dialog.show();


//obtain image info 
run("Open...");
getTitle();
title = getTitle(); 

//Beginning pre-processing steps
selectWindow(title);
run("Split Channels");
		
		//TUJ1 background pre-processing
		selectWindow("C3-" + title);
		rename("TUJ1");
		run("Subtract Background...", "rolling=20 stack");
	//	run("PureDenoise ...");
	//	waitForUser("Click when channel is de-noised"); 

		//asyn background pre-processing
		selectWindow("C2-" + title);
		rename("Asyn");
		run("Subtract Background...", "rolling=500 stack");
	//	run("PureDenoise ...");
	//	waitForUser("Click when channel is de-noised");

		//TUJ1 8-bit, thresholding, z-stack
		selectWindow("TUJ1");
		run("8-bit");
		setAutoThreshold("Triangle dark");
		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Triangle background=Dark calculate black");
	//	run("Z Project...", "projection=[Max Intensity]");
	//	selectWindow("MAX_TUJ1");
		rename("T1");
		
		
		//asyn 8-bit, thresholding, z-stack
		selectWindow("Asyn");
		run("8-bit");
		setAutoThreshold("Triangle dark");
		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Triangle background=Dark calculate black");
	//	run("Z Project...", "projection=[Max Intensity]");
	//	selectWindow("MAX_Asyn");
		rename("A1");

		//merge channels for easier identification
		run("Merge Channels...", "c5=A1 c6=T1 create ignore");
		//note that I removed z-stack option because it was creating false overlap 

	// closing unnecesary
	selectWindow("C1-" + title);
	close(); 

//changing names 
selectWindow("Composite");
rename("ss_merge");
	
//macrophage first
//run macrophage prompt
selectWindow("C4-" + title);
run("8-bit");
setAutoThreshold("Default");

run("Auto Threshold", "method=Default white stack use_stack_histogram");
run("Z Project...", "projection=[Max Intensity]");
setForegroundColor(119, 119, 119);

waitForUser("Select all macrophages using the floodfill tool (paintbucket). Click OK when done"); 


run("Threshold...");
setThreshold(88, 158);
setOption("BlackBackground", false);
run("Convert to Mask");
setThreshold(255, 255);
run("Set Measurements...", "area center perimeter limit display redirect=None decimal=3");
run("Analyze Particles...", "  show=Outlines display exclude clear summarize add");
selectWindow("Drawing of MAX_C4-" + title);


selectWindow("ss_merge");
//start roi manager and prompt 
run("ROI Manager...");
roiManager("Delete");
waitForUser("Select all + Soma (white). Hit OK when done."); 
selectWindow("ss_merge");
setTool("oval"); 


//rois to voronoi
run("Set Measurements...", "area centroid center limit redirect=None decimal=9");
roiManager("multi-measure measure_all");
selectWindow("Results");


selectWindow("ss_merge");
run("Z Project...", "projection=[Max Intensity]");
selectWindow("MAX_ss_merge"); 

//selectWindow("ss_merge");
//run("Delaunay Voronoi", "mode=Voronoi interactive inferselectionfromparticles");


//merging macrophage onto neuron channel
selectWindow("MAX_C4-" + title);
run("Analyze Particles...", "  show=Outlines display exclude clear summarize add");
run("ROI Manager...");
selectWindow("ss_merge");
roiManager("Show All without labels");
roiManager("Fill");
