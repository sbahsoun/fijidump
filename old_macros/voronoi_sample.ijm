
 
selectWindow("MAX_C4-12082119-3.nd2"); 
run("Find Maxima...", "noise=100 output=[Point Selection] light");

// Pick up image name
name = getTitle();

// Cleanup
run("Clear Results");
roiManager("Reset");

// From a point selection, get the Delaunay data
run("Delaunay Voronoi", "mode=Delaunay make export");
nR = nResults;
Roi.setName("Delaunay Graph");
run("Add Selection...");


// Variables to store
totalNeighbors = newArray(0); // Number of neighbors per point
sumDistances = newArray(0); // The total distance of all the neighbors to each point
pointIDs = newArray(0);  // The point Identifiers, made into a simple "Hash" based on their XY coordinates
pointIndexes = newArray(0); // The point indexes to help access arrays more easily.

// Go through each result
for(i=0; i<nR; i++) {
	cX1 = getResult("x1", i);
	cY1 = getResult("y1", i);
	cX2 = getResult("x2", i);
	cY2 = getResult("y2", i);
	twopoints = newArray(""+cX1+""+cY1, ""+cX2+""+cY2); // create a point identification based on the coordinates

    for(k=0; k<2; k++) {
	    pointID = twopoints[k];
	    // New point, add it to pointIDs, pointIndexes, add a new totalNeighbors entry and a new sumDistances entry
		if(isNew(pointIDs, pointID)) {
			
	        pointIDs = Array.concat(pointIDs, pointID);
			
			idx = pointIDs.length-1;
			pointIndexes = Array.concat(pointIndexes, idx);
			
			totalNeighbors = Array.concat(totalNeighbors, 0);
			
			sumDistances = Array.concat(sumDistances, 0);
	
			// Make it pretty, give this point an index and a name
			makePoint(cX1,cY1);
			Roi.setName("Object #"+IJ.pad(idx+1, 2));
			roiManager("Add");
			
		} else {
			// Point already exists
			idx = getPointIdx(pointIDs, pointID);
			
		}
	    // this point has a new neighbor
		totalNeighbors[idx]++;
	    
	    // Get distance from this point to the other point
		dist = distance(cX1, cY1, cX2, cY2);    
		sumDistances[idx] += dist;
	}
}

// Results
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

// Returns true if we have already seen this point
function getPointIdx(pointIDs, pointID) {
	for(i=0; i<pointIDs.length; i++) {
		if(pointIDs[i] == pointID) {return i}
	}
	return -1;
}

// Returns the index of the already existing point
function isNew(pointIDs, pointID) {
	for(i=0; i<pointIDs.length; i++) {
		if(pointIDs[i] == pointID) {return false}
		
	}
	return true;
}