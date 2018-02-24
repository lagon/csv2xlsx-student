writeColumnData <- function(col, colName, columnData, sheetName, workbook) {
  writeWorksheet(workbook, colName, sheetName, 1, col, header = FALSE)
  writeWorksheet(workbook, columnData, sheetName, 2, col, header = FALSE)
}

writeColumnFormula <- function(col, colName, colFormula, numRows, sheetName, workbook) {
  writeWorksheet(workbook, colName, sheetName, 1, col, header = FALSE)
  colFormula <- unlist(lapply(seq(2,numRows+1), gsub, pattern = "%&", x = colFormula))
  setCellFormula(object = workbook, sheet = sheetName, row = seq(2,numRows+1), col = col, formula = colFormula)
}

writeSingleColumn <- function(colLetter, colName, colDefinition, table, sheetName, workbook) {
  initialChar <- substr(colDefinition, 0, 1)
  
  if (initialChar == "=") {
    writeColumnFormula(
      col        = which(LETTERS %in% colLetter),
      colName    = colName,
      colFormula = substr(colDefinition, 2, 100000),
      numRows    = nrow(table),
      sheetName  = sheetName,
      workbook   = workbook
    )
  } else {
    writeColumnData(
      col        = which(LETTERS %in% colLetter),
      colName    = colName,
      columnData = table[, get(colName)],
      sheetName  = sheetName,
      workbook   = workbook
    )
  }
  
}

WriteSingleSheet <- function(table, tableFile, tableNum, workbook, conversionSetup) {
  sheetName <- paste0("Data(", tableNum, ")")
  createSheet(workbook, sheetName)
  
  messageConversionLog(" * File ", tableFile, " goes to tab ", sheetName)
  
  mapply(names(conversionSetup$ColumnNames), 
         conversionSetup$ColumnNames, 
         conversionSetup$ColumnsDefinitions, 
         FUN = writeSingleColumn, 
         MoreArgs = list(table = table, sheetName = sheetName, workbook = workbook))
  setColumnWidth(object = workbook, sheet = sheetName, column = 1:50, width = -1)
}

WriteStudentResults <- function(studentFiles, outputFilename, conversionSetup, outputDirectory) {
  excelWorkbook <- XLConnect::loadWorkbook(file.path(outputDirectory, paste0(outputFilename, ".xlsx")), create = TRUE)
  mapply(studentFiles, names(studentFiles), seq(1, length(studentFiles)), FUN = WriteSingleSheet, MoreArgs = list(workbook = excelWorkbook, conversionSetup = conversionSetup))
  saveWorkbook(excelWorkbook)
}
