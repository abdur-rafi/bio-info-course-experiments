#!/bin/bash

rootPath=$1
modelCond=$2
filePrefix=$3
jarPath=$4

if [ -z "$rootPath" ] || [ -z "$modelCond" ] || [ -z "$filePrefix" ] || [ -z "$jarPath" ]; then
    echo "Usage: ./runAstral2DatasetsEst.sh <rootPath> <modelCond> <filePrefix> <jarPath> [<file1> <file2> ...]"
    exit 1
fi


nonQuartType="B"
gtFolderPath=$rootPath/estimated-gene-trees/$modelCond
spFolderPath=$rootPath/true-specis-trees/$modelCond
consFolderPath=$rootPath/estimated-consensus-trees/$modelCond
outFolderPath=$rootPath/output-estimated-gt/$modelCond
scoresFolderPath=$rootPath/scores-estimated-gt/$modelCond



geneTreeLabel=estimatedgenetre
speciesTreeLabel=s_tree.trees
consTreeLabel=cons.greedy.tree
geneTreeLabelCleaned=gt-cleaned-resolved
geneTreeLabelCleaned=resolved_gene_tree.tre
# geneTreeLabelCleaned=gt-resolved-cleaned
speciesTreeLabelCleaned=sp-cleaned


echo "rootPath: $rootPath"
echo "Model condition: $modelCond"
echo "File prefix: $filePrefix"
echo "JAR Path: $jarPath"




mkdir -p $scoresFolderPath

> $scoresFolderPath/$filePrefix-score.txt

echo "Scores will be saved to: $scoresFolderPath/$filePrefix-score.txt"


runOne() {

    file=$1
    gtPath=$gtFolderPath/$file/$geneTreeLabelCleaned
    consPath=$consFolderPath/$file/$consTreeLabel
    spPath=$spFolderPath/$file/$speciesTreeLabelCleaned

    mkdir -p $outFolderPath/$file

    outPath=$outFolderPath/$file/$filePrefix-tree.txt

    echo $file

    # /usr/bin/env /usr/lib/jvm/java-17-openjdk-amd64/bin/java -XX:+ShowCodeDetailsInExceptionMessages -cp /home/abdur-rafi/.config/Code/User/workspaceStorage/da91ba3e148e5727246c82da7f9911d2/redhat.java/jdt_ws/E-WQFM_731a4073/bin src.Main $gtPath $consPath $outPath $nonQuartType

    java -jar "$jarPath" $gtPath $consPath $outPath $nonQuartType & PID=$!

    psrecord $PID --interval 2 --log memoryLogs/$modelCond.$file.txt --plot memoryLogs/$modelCond.$file.png
    
    wait $PID

    python3 ./rfScoreCalculator/getFpFn.py -t $spPath -e $outPath >> $scoresFolderPath/$filePrefix-score.txt

    python3 ./scripts/rfAverager.py < $scoresFolderPath/$filePrefix-score.txt > $scoresFolderPath/avg-$filePrefix-score.txt

}

if [ "$#" -gt 4 ]; then
    for (( i=5; i< $#; i++ )); do
        runOne ${!i}
    done
else
    for file in $(ls $gtFolderPath)
    do 
        runOne $file
    done
fi



