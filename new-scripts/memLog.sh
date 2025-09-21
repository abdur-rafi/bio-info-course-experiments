filePrefix="memory-astral-3"


rootPath=$1
modelCond=$2
nonQuartType="A"
gtFolderPath=$rootPath/estimated-gene-trees/$modelCond
spFolderPath=$rootPath/true-specis-trees/$modelCond
consFolderPath=$rootPath/estimated-consensus-trees/$modelCond
outFolderPath=$rootPath/output-estimated-gt/$modelCond
scoresFolderPath=$rootPath/scores-estimated-gt/$modelCond



geneTreeLabel=estimatedgenetre
speciesTreeLabel=s_tree.trees
consTreeLabel=cons-paup.tre
geneTreeLabelCleaned=gt-cleaned
speciesTreeLabelCleaned=sp-cleaned


mkdir -p $scoresFolderPath

> $scoresFolderPath/$filePrefix-score.txt

runOne() {

    file=$1
    gtPath=$gtFolderPath/$file/$geneTreeLabelCleaned
    consPath=$consFolderPath/$file/$consTreeLabel
    spPath=$spFolderPath/$file/$speciesTreeLabelCleaned

    mkdir -p $outFolderPath/$file

    outPath=$outFolderPath/$file/$filePrefix-tree.txt
    outPathT=$outFolderPath/$file/treeqmc.txt
    echo $file

    ./TREE-QMC -i $gtPath -o $outPathT & PID=$!

    psrecord $PID --interval 2 --log memoryLogs2/$modelCond.$file.treeqmc.txt --plot memoryLogs2/$modelCond.$file.treeqmc.png

    wait $PID

    cd /mnt/1e20e2ab-2438-4c8d-b9e1-29472341e409/Rafi-Rumi/wQFM-TREE ; /usr/bin/env /usr/lib/jvm/java-11-openjdk-amd64/bin/java  -cp\
    /home/bayzid/.vscode-server/data/User/workspaceStorage/b650f413ac5feee172a5ebf1f6d81ca7/redhat.java/jdt_ws/wQFM-TREE_fe900b02/bin src.Main\
    $gtPath $consPath $outPath $nonQuartType & PID=$!

    # java -jar astral.5.7.8.jar --input $gtPath --output $outPath & PID=$!;
    # psrecord $PID --interval 2 --log memoryLogs/$modelCond.astral.$file.txt --plot memoryLogs/$modelCond.astral.$file.png
    psrecord $PID --interval 2 --log memoryLogs2/$modelCond.$file.txt --plot memoryLogs2/$modelCond.$file.png
    # psrecord $PID --interval 2 --log memoryLogs/1000.10k.txt --plot memoryLogs/1000.10k.png
    
    wait $PID

    

    # python ./rfScoreCalculator/getFpFn.py -t $spPath -e $outPath >> $scoresFolderPath/$filePrefix-score.txt

    # python ./scripts/rfAverager.py < $scoresFolderPath/$filePrefix-score.txt > $scoresFolderPath/avg-$filePrefix-score.txt

}



if [ "$#" -gt 2 ]; then
    for (( i=3; i<= $#; i++ )); do
        runOne ${!i}
    done
else
    for file in $(ls $gtFolderPath)
    do 
        runOne $file
    done
fi

