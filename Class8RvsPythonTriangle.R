triangle <- function(n){
  for(i in 1:n){
    cat(paste(replicate(i, "#"), collapse = ""), "\n")
  }
}

triangle2 <- function(n){
  for(i in 1:n){
    for(j in 1:i){
      cat("#")
    }
    cat("\n")
  }
}

#def triangle(n):
#  for i in range(n):
#    print(i*"#")
