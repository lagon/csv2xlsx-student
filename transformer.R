TransformationDMU <- function(table) {
  if (nrow(table) == 0) {
    return(data.table(DMU = "X")[FALSE, ])
  }
  
  table <- cbind(
    TransformationDMUWindow(table),
    TransformationPeriod(table)[, Formated := sprintf("%02d", Period)]
  )
  data.table(
    DMU = paste(sep = "-", table$`DMU-window`, table$Formated)
  )
}

TransformationDMUWindow <- function(table) {
  if (nrow(table) == 0) {
    return(data.table("DMU-window" = "X")[FALSE, ])
  }
  
  data.table(
    "DMU-window" = ifelse(table$orderID == 0, "Hrac", paste0("Robot", table$orderID))
  )
}

TransformationPeriod <- function(table) {
  if (nrow(table) == 0) {
    return(data.table("Period" = "X")[FALSE, ])
  }
  
  data.table(
    "Period" = (1:nrow(table)-1) %/% 4 + 1
  )
}

MakeSingleDataTransformation <- function(tranformation, table) {
  switch(tranformation,
         "#DMU"        = TransformationDMU(table),
         "#DMU-window" = TransformationDMUWindow(table),
         "#Period"     = TransformationPeriod(table),
         stop("XXX"))
}

MakeAllDataTransformations <- function(table, columnDefinitions) {
  transformations <- columnDefinitions[substr(columnDefinitions, 0, 1) == "#"]
  
  transRes <- Reduce('cbind', lapply(transformations, MakeSingleDataTransformation, table = table))
  cbind(table, transRes)
}

FilterAndOrderTable <- function(table, columnNames, columnsDefinitions) {
  dataColumns <- names(columnsDefinitions[substr(columnsDefinitions, 0, 1) != "="])
  columnNames <- columnNames[dataColumns]
  columnNames <- unlist(columnNames[order(names(columnNames))])
  table[, .SD, .SDcols = c(columnNames)]
}

TransformSingleTable <- function(table, conversionSetup) {
  table <- MakeAllDataTransformations(table, conversionSetup$ColumnsDefinitions)
  table <- FilterAndOrderTable(table, conversionSetup$ColumnNames, conversionSetup$ColumnsDefinitions)
  table
}

TransformStudentData <- function(studentFiles, conversionSetup) {
  lapply(studentFiles, TransformSingleTable, conversionSetup = conversionSetup)
}
