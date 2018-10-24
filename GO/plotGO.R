library(ggplot2)

GO <- read.table("input_GO.R",header = T, sep = "\t")

GO <- GO[order(GO$adjPvalue),c(1,3,4,2)]
GO

svg("go_out.svg",width=14,height=7)
p<-ggplot(data=GO, aes(x= GO, y=N)) + geom_point(aes (colour = Code, size=-log(adjPvalue)))
p
# Horizontal bar plot
p + coord_flip() +ggtitle("GO Enrichment Analysis") + theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5), panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()
