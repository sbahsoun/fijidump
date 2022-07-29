//Nearest Neighbor Analysis 
/*Outline:
 * Pre-processing
 * Distance to each cell
 * Arrange in increasing order
 * Pull the minimum value for each cell
 * Arrange this minimum value to each cell number
*/

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
close();


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
run("Duplicate...", "title=new");

//String.copyResults();
//waitForUser("Results are copied! Paste into spreadsheet"); 

selectWindow("new");
run("Find Maxima...", "noise=100 output=[Point Selection] light");

// Pick up image name
name = ("new");
// Cleanup
run("Clear Results");
roiManager("Reset");

// From a point selection, get the Delaunay data
run("Delaunay Voronoi", "mode=Delaunay make export");
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

		function doSort(twopoi){

			print ("\\Clear");
			sortedValues = Array.copy(twopoints);
			Array.sort(sortedValues);
			rankPosArr = Array.rankPositions(theArray);
			ranks = Array.rankPositions(rankPosArr);
	

	
			print ("\nSorted array (starting with smallest value):");
			for (jj = 0; jj < twopoints.length; jj++){
				print(sortedValues[jj]);
			}

	
}
  /*  for(k=0; k<2; k++) {
	    pointID = twopoints[k];
		if(isNew(pointIDs, pointID)) {
			
	        pointIDs = Array.concat(pointIDs, pointID);
			
			idx = pointIDs.length-1;
			pointIndexes = Array.concat(pointIndexes, idx);
			
		//	totalNeighbors = Array.concat(totalNeighbors, 0);
			
		//	sumDistances = Array.concat(sumDistances, 0);
	
	
			makePoint(cX1,cY1);
			Roi.setName("Object #"+IJ.pad(idx+1, 2));
			roiManager("Add");
			
		} else {
			// Point already exists
			idx = getPointIdx(pointIDs, pointID);
			
		}

//		totalNeighbors[idx]++;


		dist = distance(cX1, cY1, cX2, cY2);    
	//	sumDistances[idx] += dist;
	}
}

// Results prompt 
IJ.renameResults("Nearest Neighbor Analysis Results");
for(i=0; i<pointIDs.length; i++) {
	setResult("Label", i, name);
	setResult("N Neighbor Distance", i, n_neighbor[i]); 

}

// Compute XY distance
function distance(x1,y1,x2,y2) {
	return sqrt((x1-x2) * (x1-x2) + (y1-y2) * (y1-y2));
}


}
