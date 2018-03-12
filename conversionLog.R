initConversionLog <- function(studentName, studentDirectory) {
  options(
    conversionLog = list(
      StudentName = studentName, 
      Messages = list(paste0("Reading from: ", studentDirectory))
    )
  )
}

messageConversionLog <- function(...) {
  message <- paste0(...)
  conversionLog <- getOption("conversionLog", list())
  if (length(conversionLog) == 0) {
    warning("Conversion log was not initiated. Trashing the message: ", message)
  }
  conversionLog$Messages <- append(conversionLog$Messages, message)
  options(conversionLog = conversionLog)
}

.writeConversionLog <- function(logFilePath) {
  conversionLog <- getOption("conversionLog", list())
  if (length(conversionLog) == 0) {
    warning("Conversion log was not initiated. Can not write out.")
  }
  
  tryCatch({
    logFile <- file(description = logFilePath, open = "w")
    writeLines(text = unlist(conversionLog$Messages), con = logFile)
  },
  error = function(e) {
    warning(paste0("Unable to write log file: ", logFilePath))
  }, 
  finally = close(logFile))
}

writeSuccessfullConversionLog <- function(outputDirectory) {
  conversionLog <- getOption("conversionLog", list())
  if (length(conversionLog) == 0) {
    warning("Conversion log was not initiated. Can not write out.")
  }
  logFilePath <- file.path(outputDirectory, paste0(conversionLog$StudentName, ".txt"))
  .writeConversionLog(logFilePath)
}

writeFailedConversionLog <- function(outputDirectory) {
  conversionLog <- getOption("conversionLog", list())
  if (length(conversionLog) == 0) {
    warning("Conversion log was not initiated. Can not write out.")
  }
  logFilePath <- file.path(outputDirectory, paste0(conversionLog$StudentName, ".failed.txt"))
  .writeConversionLog(logFilePath)
}

