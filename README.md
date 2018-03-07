# Convertor csv2xlsx-student
Convertor for results of student's simulations in CSV to XLSX.

## Software Prerequisities

  + R Runtime - (https://mirrors.nic.cz/R/)
  + R Studio  - (https://www.rstudio.com/products/rstudio/download/#download)
  + Java - (https://java.com/en/download)

Download and install all three software packages.

## Convertor Download and Open

As a next step download and extract latest version of the conversion tool from (https://github.com/lagon/csv2xlsx-student). Use the green button "Clone or Download" and then select "Download ZIP".

When downloaded, start R Studio. From the right-top corner select "New Project", then select "Existing Directory" and select the directory where you have extracted the source conversion tool. The R Studio should import the tool so you can easily use it.

## Setup

All the setup is done in file named _setup.R_. There are three sections:

 1. studentProjectsDirectory -- this is a main directory where the results of student simulations are stored. Each student is supposed to have one directory with multiple CSV files.
 2. outputDirectory -- In this directory where the converted excel seheets will be stored.
 3. conversionSetup -- A set of excel columns and their definitions (see below).

  > Regarding the 1. and 2. -- The directories should be refered to by absolute path. The easied way to get to navigate to the directory in Explorer (File Window) and the click on address line. It should change from graphical representation to free text you can copy and paste here.

### Column Specification

The specification is in form of two lists. Both lists are named with Excel columns. The first list named ```ColumnNames``` gives header names for each column. The second list ```ColumnsDefinitions``` indicates what should the column contain. Currently there are three types of content that can be there.

 1. A column straight from the CSV file. To use it give name of the column name from the CSV.
 2. An Excel formula. Simply give an excel formula starting with equal sign (=). Note that there is a placeholder ```%&``` which is substituted with row number.
 3. An internal transformation. To specify it use ```#``` and name of the transformation. Currently there are three -- _#DMU_, _#DMU-window_ and _#Period_ which produce content for the three columns as requested.

There is also an option named ```SkipLines``` to specify how many lines in the each CSV file are the header and should be skipped before starting to read the data.

Below is an example of the configuration:
```
studentProjectsDirectory <- "~/Sources/CSV2XLS/Input"
outputDirectory <- "~/Sources/CSV2XLS/Output"

conversionSetup <- list(
  SkipLines = 3, # How many lines to skip in the CSV file
  ColumnNames = list( # What header name each column should have.
    "A" = "DMU",
    "B" = "DMU-window",
    "C" = "Period",
    "D" = "rawMaterialAvailable",
    "E" = "rawMaterialMinimumCost",
    "F" = "potentialMarketForFinishedInventory",
    "G" = "maxMarketValueForFinishedInvetory",
    "H" = "account",
    "I" = "productFinalySell",
    "J" = "loan",
    "K" = "rawMaterialMinimumCostNEW",
    "L" = "accountNEW"
  ),
  
  ColumnsDefinitions = list( # Define the content of each column.
    "A" = "#DMU",
    "B" = "#DMU-window",
    "C" = "#Period",
    "D" = "rawMaterialAvailable",
    "E" = "rawMaterialMinimumCost",
    "F" = "potentialMarketForFinishedInventory",
    "G" = "maxMarketValueForFinishedInvetory",
    "H" = "account",
    "I" = "productFinalySell",
    "J" = "loan",
    "K" = "=(MAX($E$2:$E$49)+MIN($E$2:$E$49))-E%&",
    "L" = "=H%&-J%&"
  )
)
```

> Note that the excel columns (A, B, C, ...) should be the same in both lists. The tool checks that and complains if there are discrepancies.

> Currently the conversion tool supports using only first 26 columns (A - Z) in the Excell.

## Running the Conversion

To run the conversion, open the file named _main.R_ and select "Run" from the top or use shortcut *Ctrl+Shift+S*.

The conversion tool is supposed to be self contained and should check and download all required libraries. If it fail, try install them manually by running: ```install.packages(c("data.table", "XLConnect", "rJava"))``` from within R Studio.

Where running the conversion tool for the first time, you may need to point R to correct location of Java. The conversion tool tries to do it on its own and it may be necessary to re-run the tool after that (use *"Restart R"* from *Session* menu to restart the environment). If it fail, it may be necessary to close the R Studio and run following command ```R CMD javareconf``` from the terminal.


