### Copyright (c) 2019 | Asif Al Faisal | Data Analyst | email: faisal.iit.du@gmail.com | CIMMYT-Bangladesh ###


library(raster)
library(rasterVis)
library(sp)
library(rgdal)
library(RStoolbox)
library(ggplot2)


crop_name = "Aman"
season = ""
idx = "EVI"
directory <- paste0("E:\\CIMMYT\\Asif Workspace\\Output_20190917\\",idx,"\\",crop_name,"\\",season,"\\")


setwd(directory)
getwd()

files <- dir(directory,recursive=TRUE, full.names=TRUE, pattern="\\.tif$")
write.table(files, file = "inputRasters.txt", row.names = F)

st.idx <- stack(files)
idx.scale <- scale(st.idx)

idx.scale[is.na(idx.scale)] <- 99999999
rpc <- rasterPCA(idx.scale, nComp = 5)

output <- summary(rpc$model)


vars <- output$sdev^2
vars <- vars/sum(vars)


write.csv(rbind("Standard deviation" = output$sdev, 
                "Proportion of Variance" = vars,
                "Cumulative Proportion" = cumsum(vars)), 
          file="Output.csv")



PC<-c()

for (i in 1:dim(rpc$map)[3]){
  
  #### PC[i] = c(evalulation(expression)) *** parse() creates expression from string ###
  
  PC[i] <- c(eval(parse(text=paste0("rpc$map$PC",i)))) 
  writeRaster(PC[[i]], filename = paste0(idx,"_PC",i,"_0",".tiff"), "GTiff", overwrite=T)
  
}

