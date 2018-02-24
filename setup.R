studentProjectsDirectory <- "~/Sources/CSV2XLS/Input"
outputDirectory <- "~/Sources/CSV2XLS/Output"



conversionSetup <- list(
  SkipLines = 3,
  ColumnNames = list(
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
  
  ColumnsDefinitions = list(
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
