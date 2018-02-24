ReadListOfStudentProjects <- function(studentProjectsDirectory) {
  dirs <- list.files(studentProjectsDirectory, full.names = TRUE)
  showDirs <- min(3, length(dirs))
  cat(paste0("There are ", length(dirs), " student directories. First ", showDirs, " are following:\n"))
  mapply(head(dirs, showDirs), seq(1, showDirs), FUN = function(d, n) {
    cat(paste0("    ", n, ") ", d,"\n"))
  })
  cat("\n")
  dirs
}

LoadFilesInStudentDirectory <- function(studentDirectory, skipLines) {
  messageConversionLog("Looking for student results in ", studentDirectory)
  csvFiles <- list.files(studentDirectory, full.names = TRUE, pattern = ".*\\.csv")
  cat(paste0(length(csvFiles), " files"))
  csvFiles <- sort(csvFiles)
  
  loadedData <- lapply(csvFiles, function(f, skipLines) {
    messageConversionLog("   + reading: ", f)
    table <- fread(input = f, skip = skipLines)
    messageConversionLog("       + read ", nrow(table), " lines")
    table
  }, skipLines = skipLines)
  names(loadedData) <- basename(csvFiles)
  loadedData
}
