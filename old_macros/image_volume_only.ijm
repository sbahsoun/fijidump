

#@ File (label = "Input directory", style = "directory") input
#@ String (label = "File suffix", value = ".nd2") suffix


processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, list[i]);
	}
}


function processFile(input, file) {
run("Open...");
getTitle();
title = getTitle(); 
selectWindow(title);
getDimensions(width, height, channels, slices, frames);
print("Total Image Area");
print(width * height * slices); 
	//print("Processing: " + input + File.separator + file);
	//print("Saving to: " + output);
	close();
}
