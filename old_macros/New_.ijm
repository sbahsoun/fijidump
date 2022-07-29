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

//new distance measurements
for(cont=0;cont<nResults;cont++){
	x1=getResult("XM",cont);	
	y1=getResult("YM",cont);
		
	for(cont2=cont;cont2<nResults;cont2++){
			x2=getResult("XM",cont2);	
			y2=getResult("YM",cont2);
			if(cont==cont2){
				distance=0;	
			}
			else{
			distance=round(sqrt((x2-x2)^2)+(y2-y1)^2);
			
			}
			//create an array for these distance values 
	/*	function doSort(distance){

			print ("\\Clear");
			sortedValues = Array.copy(distance);
			Array.sort(sortedValues);
			rankPosArr = Array.rankPositions(distance);
			ranks = Array.rankPositions(rankPosArr);
	

	
			print ("\nSorted array (starting with smallest value):");
			for (jj = 0; jj < distance.length; jj++){
				print(sortedValues[jj]);
			}
*/ 
	
}

		//	print(distance); //(validation that distance is working properly 
			//
		//	setPixel(cont,cont2,distance);
		//	setPixel(cont2,cont,distance);
	}
}
//twopoints = newArray(""+cX1+""+cY1, ""+cX2+""+cY2); // point id for each coordinate

//original voronoi distance measurmenets
/*


//create point IDs as a hash based on the XY coordinate of each maxima
pointIDs = newArray(0); 


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
			
		//	totalNeighbors = Array.concat(totalNeighbors, 0);
			
		//	sumDistances = Array.concat(sumDistances, 0);
	
	
			makePoint(cX1,cY1);
			Roi.setName("Object #"+IJ.pad(idx+1, 2));
			roiManager("Add");
			
		} else {
			// Point already exists
			idx = getPointIdx(pointIDs, pointID);
			
		}

	//	totalNeighbors[idx]++;
	    

		dist = distance(cX1, cY1, cX2, cY2);    
		print(dist);
	//	sumDistances[idx] += dist;
	}
}
 

// Results prompt 
IJ.renameResults("Raw");
for(i=0; i<pointIDs.length; i++) {
	//setResult("Label", i, name);
	setResult("Object", i, pointIndexes[i]+1);
//	setResult("N Neighbors", i, totalNeighbors[i]);
//	setResult("Average Distance", i, sumDistances[i]/totalNeighbors[i]);
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

//steps:
/* 1. Find distance betwen maxima
 * 2. Arrange distances in array, from least distance to greatest
 * 3. Grab the first distance (least amount)
 * 4. Use that as the nearest neighbor value 
 * 5. Output only the smallest distance after every macrophage 
 *  
 *  
 *  TO DO:
 *  Create arrray with two points w/ distance 
 *  Correspond the macrophage numbers with distance: 
 *  Goal: Retrieve the smallest twopoint values
 *  1. get to array, 2. filter by n number minimum values (n is the total number of macrophages) 
 */