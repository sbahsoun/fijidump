// this macro quantifies overlap between individual macrophages and tuj1 channel
//better than channel overlap 

//Obtain image info
run("Open...");
getTitle();
title = getTitle(); 

//Close out channels
selectWindow(title);
run("Split Channels");
selectWindow("C2-" + title);
close();
selectWindow("C1-" + title);
close();
selectWindow("C3-" + title);
rename("Neuron"); 
//adjust brightness, z-project 

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
run("Duplicate...", "title=voronoi");
run("Duplicate...", "title=new");

//get area for each macrophage
roiManager("multi-measure measure_all");
//selectWindow("Results");

//waitForUser("Copy measurements of macrophages before ROI is cleared in next step!"); 

selectWindow("Neuron");
setAutoThreshold("Triangle dark");
run("Convert to Mask", "method=Triangle background=Dark calculate black");
run("Magenta");
run("Z Project...", "projection=[Max Intensity]");
selectWindow("MAX_C4-" + title);
rename("macrophage");
imageCalculator("AND create", "MAX_Neuron","macrophage");
selectWindow("Result of MAX_Neuron");

setAutoThreshold("Default dark");

run("Convert to Mask");
roiManager("Show All");
roiManager("Show All with labels");
roiManager("multi-measure measure_all");

//waitForUser("Copy measurements of overlap area!"); 

/*
//part 3
//selectWindow("voronoi");
//run("Set Measurements...", "area center perimeter limit display redirect=None decimal=3");
selectWindow("voronoi"); 
run("Find Maxima...", "noise=100 output=[Point Selection] light");

// Pick up image name
name = ("voronoi");
// Cleanup
run("Clear Results");
roiManager("Reset");

// From a point selection, get the Delaunay data
run("Delaunay Voronoi", "mode=Delaunay make export");
//run("Set Measurements...", "area center perimeter limit display redirect=None decimal=3");
//run("Delaunay Voronoi", "mode=Delaunay inferselectionfromparticles");

nR = nResults;
Roi.setName("Delaunay Graph");
run("Add Selection...");



totalNeighbors = newArray(0); 
sumDistances = newArray(0);
pointIDs = newArray(0);  
pointIndexes = newArray(0); 

//go through each measurement 
for(i=0; i<nR; i++) {
	cX1 = getResult("x1", i);
	cY1 = getResult("y1", i);
	cX2 = getResult("x2", i);
	cY2 = getResult("y2", i);
	twopoints = newArray(""+cX1+""+cY1, ""+cX2+""+cY2); // point id for each coordinate

    for(k=0; k<2; k++) {
	    pointID = twopoints[k];
		if(isNew(pointIDs, pointID)) {
			
	        pointIDs = Array.concat(pointIDs, pointID);
			
			idx = pointIDs.length-1;
			pointIndexes = Array.concat(pointIndexes, idx);
			
			totalNeighbors = Array.concat(totalNeighbors, 0);
			
			sumDistances = Array.concat(sumDistances, 0);
	
	
			makePoint(cX1,cY1);
			Roi.setName("Object #"+IJ.pad(idx+1, 2));
			roiManager("Add");
			
		} else {
			// Point already exists
			idx = getPointIdx(pointIDs, pointID);
			
		}

		totalNeighbors[idx]++;


		dist = distance(cX1, cY1, cX2, cY2);    
		sumDistances[idx] += dist;
	}
}

// Results prompt 
IJ.renameResults("Raw From Delaunay");
for(i=0; i<pointIDs.length; i++) {
	setResult("Label", i, name);
	setResult("Object", i, pointIndexes[i]+1);
	setResult("N Neighbors", i, totalNeighbors[i]);
	setResult("Average Distance", i, sumDistances[i]/totalNeighbors[i]);
}

// Compute XY distance
function distance(x1,y1,x2,y2) {
	return sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1-y2));
}

// ignore repeat points
function getPointIdx(pointIDs, pointID) {
	for(i=0; i<pointIDs.length; i++) {
		if(pointIDs[i] == pointID) {return i}
	}
	return -1;
}

// index of existing pt 
function isNew(pointIDs, pointID) {
	for(i=0; i<pointIDs.length; i++) {
		if(pointIDs[i] == pointID) {return false}
		
	}
	return true;
}
*/

 
