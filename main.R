bootstrap <- function() {
  if (!all(c("data.table", "XLConnect") %in% installed.packages())) {
    cat("Some of the required packages not present, trying to install... Required libraries are data.table, XLConnect and rJava.\n")
    install.packages(c("data.table", "XLConnect", "rJava"))
    cat("Configuring rJava.\n")
    if (system("R CMD javareconf") != 0) {
      cat("'R CMD javareconf' failed. Make sure, you have Java JDK installed (check www.java.com) and try manually (or maybe even without).")
    }
    cat("Configuration complete. You may need to restart the conversion tool if it fail later.")
  }
  library(data.table)
  library(XLConnect)
}

ValidateConversionSetup <- function(studentProjectsDirectory, conversionSetup, outputDirectory) {
  logMessages <- list()
  shouldFail <- FALSE
  if (!dir.exists(studentProjectsDirectory)) {
    shouldFail <- TRUE
    logMessages <- append(logMessages, paste0("Student project directory (", studentProjectsDirectory, ") does not exist."))
  }
  
  if (!dir.exists(outputDirectory)) {
    shouldFail <- TRUE
    logMessages <- append(logMessages, paste0("Output directory (", outputDirectory, ") does not exist."))
  }
  
  if (length(setdiff(names(conversionSetup$ColumnNames), names(conversionSetup$ColumnsDefinitions))) > 0 &&
      length(setdiff(names(conversionSetup$ColumnsDefinitions), names(conversionSetup$ColumnNames))) > 0) {
    shouldFail <- TRUE
    logMessages <- append(logMessages, paste0("The column letters in names and definitions doesn't match."))
  }
  
  if (shouldFail) {
    cat("Following issues were found, can not continue.\n")
    lapply(X = logMessages, FUN = function(s) {cat(paste0("   * ", s, "\n"))})
    stop()
  }
  
  cat("Setup looks OK.\n")
}

ProcessSingleStudent <- function(studentDirectory, conversionSetup, outputDirectory) {
  tryCatch({
    initConversionLog(basename(studentDirectory), studentDirectory)
    cat(paste0("Processing student: ", basename(studentDirectory), "..."))
    studentFiles <- LoadFilesInStudentDirectory(studentDirectory, conversionSetup$SkipLines)
    cat("...")
    studentFiles <- TransformStudentData(studentFiles, conversionSetup)
    cat("...")
    WriteStudentResults(studentFiles, basename(studentDirectory), conversionSetup, outputDirectory)
    cat("...DONE\n")
    writeSuccessfullConversionLog(outputDirectory)
  }, error = function(e) {
    messageConversionLog(e)
    writeFailedConversionLog(outputDirectory)
  })
}


bootstrap()
source("setup.R")
source("loader.R")
source("transformer.R")
source("saver.R")
source("conversionLog.R")


ValidateConversionSetup(studentProjectsDirectory, conversionSetup, outputDirectory)

studentList <- ReadListOfStudentProjects(studentProjectsDirectory)

lapply(studentList, ProcessSingleStudent, conversionSetup = conversionSetup, outputDirectory = outputDirectory)

