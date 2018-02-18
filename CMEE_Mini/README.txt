CMEE Mini project README

This directory is organised into several folders, with the run_MiniProject shell script pulling the project together.

Code:
	Contains all code for the project, both the Python and R scripts.
	Packages used:
		-Python, version 3.6.3: 
			Model fitting and analysis:
			-statsmodels		-lmfit
			-sklearn		
			Plotting:
			-seaborn		-matplotlib
			Physical Constants (Boltzman constant):
			-scipy	
			Dataframe manipulation: 
			-numpy			-pandas
			Setting random seed:
			-random	
			Calling R script:		
			-subprocess		
			
		-R, version 3.2.3:
			Plotting graphs:
			-ggplot			-grid
Data:
	Contains all the data used for the project.
	-Original data			-Data with additional columns for analysis, plotting etc.
	snail_feeding_EG.csv		Feeding_data.csv
	snail_respiration_BK.csv	Respiration_data.csv
Results:
	Contains all results used for the project. Both graphs and parameter values.

Papers:
	Contains initial papers used to begin project, aid in processing results
	and see how data was collected.
Report:
	Contains all necessary documents and files to compile the Pdf report. Within this 
	directory there is a Sections folder containing the individual LaTeX sections of 
	the report.

Sandbox:
	Contains all documents that are no longer essential to this report. All ipynb are
	in this directory as relevant nb were downloaded as Python or R files and placed into
	the code folder. 
