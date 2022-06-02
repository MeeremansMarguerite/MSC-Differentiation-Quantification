//MSC DIFFERENTIATION QUANTIFICATION, based on a differentiation ratio - OIL RED O + HEMATOXYLIN (Adipogenic)
	//Images order : Name images easy (short)
					//DO NOT take pictures using phase-contrast
					//ALWAYS take a darkfield (name: "1Dark.tif") and a lightfield (name: "1Light.tif") at the same moment of your sample pictures
					//Make sure these are the first 2 images per folder to analyze
					//For more information, see "README"-file
	//Uses Color Deconvolution with user defined thresholds
	//Determine scale on 1 image with scale bar and set as global scale (Adjust line 35), ALL IMAGES SAME MAGNIFICATION
	//Make sure the right global scale is active!! ((G) next to image name)
	//FIRST install the plugin "Results to Excel" via https://imagej.net/plugins/read-and-write-excel
	//Images to analyze: save in .tiff/.jpg WITHOUT scalebar printed (this can wrongly be recognized as a signal)
	//Written by MARGUERITE MEEREMANS (2022-01-07), marguerite.meeremans@ugent.be

	//Get folder containing images
rep=getDirectory("Choose a folder");
list=getFileList(rep);

	//Define measurements & clear previous results
run("Set Measurements...", "area area_fraction limit display redirect=None decimal=2");
run("Clear Results");

	//Create a new excel file to save the results
		//Adjust the path, copy the desired path from your document folder bar and adjust \ into /
run("Read and Write Excel", "file=[C:/Users/mmeer/Documents/UGent/2020_Physiology_Regenerative Promise MSCs_MM/1. Cells/AT-MSCs/Article_MSCs differentiation quantification/Data Processing/20220203_bATMSC Diff Calf/Adipogenic/OilRed.xlsx] file_mode=read_and_open");
  
	//Image analysis, starts from the third image in the folder
 		//Image 1 & 2 SHOULD be a darkfield and a lightfield image 
for(i=2;i<list.length ;i=i+1)
{
nom=list[i];
path= rep+nom;
open(path);

	//Adjust to correct scale based on preview image
run("Set Scale...", "distance=426 known=100 unit=µm global");
run("Clear Results");
	//Sample image is open + opens darkfield & lightfield image
open(rep + "1Light.tif");
open(rep + "1Dark.tif");

	//To correct for different exposure & illumination settings a correction is applied
imageCalculator("Subtract create", "1Light.tif","1Dark.tif");
imageCalculator("Subtract create", nom ,"1Dark.tif");
selectWindow("Result of " + nom);
run("Duplicate...", "title=Sample");
close("Result of " + nom);
run("Calculator Plus", "i1=[Sample] i2=[Result of 1Light.tif] operation=[Divide: i2 = (i1/i2) x k1 + k2] k1=255 k2=0 create");

	//Apply colour deconvolution based on user defined values to achieve accurate stain separation
selectWindow("Result");
run("Colour Deconvolution2", "vectors=[User values] output=[8bit_Transmittance] simulated cross [r1]=0.3444278036120452 [g1]=0.6996578556225743 [b1]=0.6259779334486187 [r2]=0.7025544744811385 [g2]=0.6808652139073618 [b2]=0.2069777062328551 [r3]=0.0 [g3]=0.0 [b3]=0.0");
close("Result-(Colour_3)");

	//Purple colours = background (image in channel 2, C2), Hematoxylin
selectWindow("Result-(Colour_2)");
run("Duplicate...", "title=B#"+ nom);
close("Result-RGB_Keep_C2");
selectWindow("B#"+ nom);
run("8-bit");

	//Thresholding based on user defined values
setAutoThreshold("Default dark");
setThreshold(0, 125);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Fill Holes");
run("Measure");
close("B#"+ nom);

	// Red colours = signal, Lipid droplets (image in channel 1, C1), based on Oil Red O staining
selectWindow("Result-(Colour_1)");
run("Duplicate...", "title=R#"+ nom);
close("Result-RGB_Keep_C1");
selectWindow("R#"+ nom);
run("8-bit");

	//Thresholding based on user defined values
setAutoThreshold("Mean");
setThreshold(0, 115);
setOption("BlackBackground", false);
run("Convert to Mask");
run("Measure");

close("R#"+ nom);
close(nom);

selectWindow("Colour Deconvolution");
run("Close");
	//Results are saved in a list in the excel files named in line 22
run("Read and Write Excel", "stack_results file_mode=queue_write");
run("Close All");
}

run("Read and Write Excel", "file_mode=write_and_close");

selectWindow("Results");
run("Close");
selectWindow("Log");
run("Close");

//ANALYSIS:
//Divide the % Red by the % Background (representative for the number of cells, cell culture area, hematoxylin stained)

//Optional: include manual Brightness/Contrast settings for better analysis (if needed).
	//AUTOMATIC
		//setMinAndMax(10, 90);
		//run("Apply LUT");
	//MANUALLY
		//title= "Brightness/Contrast";
		//msg = "If necessary use \"Brightness/ Contrast \" tool\n (Image>Adjust>Brightness/Contrast)\nto adjust then click \"ok\"";
		//waitForUser(title,msg);
