timestamp=$(date +"%Y%m%d_%H%M%S")

wqfmVanillaOutput="wqfm-vanilla-${timestamp}.tre"
wqfmVanillaOutput="wqfm-vanilla.tre"
wqfmExpOutput="wqfm-exp-${timestamp}.tre"

wqfmVanillaScore="wqfm-vanilla-score-${timestamp}.txt"
wqfmExpScore="wqfm-exp-score-${timestamp}.txt"

crossCheckScore="cross-check-score-${timestamp}.txt"



rootPath=$1
modelCond=$2


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
speciesTreeLabelCleaned=sp-cleaned


mkdir -p $scoresFolderPath


wqfmTreeVanillaPath='/Users/abdurrafi/Desktop/masters/2nd Term/BIO/wqfm-tree/wQFM-TREE-v1.0.1/wQFM-TREE-v1.0.1.jar'
wqfmExpPath="/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/java -XX:+ShowCodeDetailsInExceptionMessages -cp /Users/abdurrafi/Library/Application\ Support/Code/User/workspaceStorage/fc8ecc0351dfea41b8df11620497201c/redhat.java/jdt_ws/wQFM-TREE_ad2ee5d7/bin"


echo "WQFM-Vanilla path: $wqfmTreeVanillaPath"
echo "WQFM-Exp path: $wqfmExpPath"
echo "WQFM-vanilla output: $wqfmVanillaOutput"
echo "WQFM-exp output: $wqfmExpOutput"
echo "WQFM-vanilla score file: $wqfmVanillaScore"
echo "WQFM-exp score file: $wqfmExpScore"
echo "Cross-check score file: $crossCheckScore"
echo "Model condition: $modelCond"

runVanilla() {
    file=$1
    gtPath=$gtFolderPath/$file/$geneTreeLabelCleaned
    consPath=$consFolderPath/$file/$consTreeLabel
    spPath=$spFolderPath/$file/$speciesTreeLabelCleaned
    mkdir -p $outFolderPath/$file
    wqfmVanillaOutPath=$outFolderPath/$file/$wqfmVanillaOutput
    echo $file
    java -jar "$wqfmTreeVanillaPath" $gtPath $consPath $wqfmVanillaOutPath $nonQuartType
    python ./rfScoreCalculator/getFpFn.py -t $spPath -e $wqfmVanillaOutPath >> $scoresFolderPath/$wqfmVanillaScore
    python ./scripts/rfAverager.py < $scoresFolderPath/$wqfmVanillaScore > $scoresFolderPath/avg-$wqfmVanillaScore
}

runExp() {
    file=$1
    gtPath=$gtFolderPath/$file/$geneTreeLabelCleaned
    consPath=$consFolderPath/$file/$consTreeLabel
    spPath=$spFolderPath/$file/$speciesTreeLabelCleaned
    mkdir -p $outFolderPath/$file
    wqfmExpOutPath=$outFolderPath/$file/$wqfmExpOutput
    echo $file
    /usr/bin/env /Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/bin/java -XX:+ShowCodeDetailsInExceptionMessages -cp /Users/abdurrafi/Library/Application\ Support/Code/User/workspaceStorage/fc8ecc0351dfea41b8df11620497201c/redhat.java/jdt_ws/wQFM-TREE_ad2ee5d7/bin src.Main $gtPath $consPath $wqfmExpOutPath $nonQuartType
    python ./rfScoreCalculator/getFpFn.py -t $spPath -e $wqfmExpOutPath >> $scoresFolderPath/$wqfmExpScore
    python ./scripts/rfAverager.py < $scoresFolderPath/$wqfmExpScore > $scoresFolderPath/avg-$wqfmExpScore
}

runCrossCheck() {
    file=$1
    wqfmVanillaOutPath=$outFolderPath/$file/$wqfmVanillaOutput
    wqfmExpOutPath=$outFolderPath/$file/$wqfmExpOutput
    python ./rfScoreCalculator/getFpFn.py -t $wqfmVanillaOutPath -e $wqfmExpOutPath >> $scoresFolderPath/$crossCheckScore
    python ./scripts/rfAverager.py < $scoresFolderPath/$crossCheckScore > $scoresFolderPath/avg-$crossCheckScore
}


# Usage: ./runAstral2DatasetsEst.sh <rootPath> <modelCond> [mode] [file1 file2 ...]
# mode: vanilla, exp, both (default: both)
mode="both"
if [ "$#" -ge 3 ]; then
    mode=$3
fi


# Reset relevant score files only once before running the section
if [ "$mode" = "vanilla" ]; then
    > $scoresFolderPath/$wqfmVanillaScore
elif [ "$mode" = "exp" ]; then
    > $scoresFolderPath/$wqfmExpScore
else
    > $scoresFolderPath/$wqfmVanillaScore
    > $scoresFolderPath/$wqfmExpScore
    > $scoresFolderPath/$crossCheckScore
fi

if [ "$#" -gt 3 ]; then
    startIdx=4
    endIdx=$#
    for (( i=startIdx; i <= endIdx; i++ )); do
        file=${!i}
        if [ "$mode" = "vanilla" ]; then
            runVanilla $file
        elif [ "$mode" = "exp" ]; then
            runExp $file
        else
            runVanilla $file
            runExp $file
            runCrossCheck $file
        fi
    done
else
    for file in $(ls $gtFolderPath)
    do
        if [ "$mode" = "vanilla" ]; then
            runVanilla $file
        elif [ "$mode" = "exp" ]; then
            runExp $file
        else
            runVanilla $file
            runExp $file
            runCrossCheck $file
        fi
    done
fi



