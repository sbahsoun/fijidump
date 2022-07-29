
//getting title for universal macro use
getTitle();
title = getTitle()

title = "file-name"

//Split chnnels and single-out alpha syn channel
run( "Split Channels");
selectWindow("title");
rename ("Alpha Syn"); 
