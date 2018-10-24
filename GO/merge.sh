echo "GO,N,adjPvalue,Code"| sed 's/,/\t/g' > header
cat header GO_BP.txt  GO_CC.txt  GO_MF.txt > input_GO.R
