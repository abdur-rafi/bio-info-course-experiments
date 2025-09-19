timestamp=$(date +"%Y%m%d_%H%M%S")

rootPath=$1
modelCond=$2



wqfmVanillaOutput="$3"
wqfmExpOutput="$4"

crossCheckScore="cross-check-score-${timestamp}.txt"

gtFolderPath=$rootPath/estimated-gene-trees/$modelCond
outFolderPath=$rootPath/output-estimated-gt/$modelCond
scoresFolderPath=$rootPath/scores-estimated-gt/$modelCond

> $scoresFolderPath/$crossCheckScore


echo "WQFM-vanilla output: $wqfmVanillaOutput"
echo "WQFM-exp output: $wqfmExpOutput"
echo "Cross-check score file: $crossCheckScore"

runCrossCheck() {
    file=$1
    wqfmVanillaOutPath=$outFolderPath/$file/$wqfmVanillaOutput
    wqfmExpOutPath=$outFolderPath/$file/$wqfmExpOutput
    python ./rfScoreCalculator/getFpFn.py -t $wqfmVanillaOutPath -e $wqfmExpOutPath >> $scoresFolderPath/$crossCheckScore
    python ./scripts/rfAverager.py < $scoresFolderPath/$crossCheckScore > $scoresFolderPath/avg-$crossCheckScore
}




if [ "$#" -gt 4 ]; then
    startIdx=5
    endIdx=$#
    for (( i=startIdx; i <= endIdx; i++ )); do
        file=${!i}
        runCrossCheck $file
    done
else
    for file in $(ls $gtFolderPath)
    do
        runCrossCheck $file
    done
fi



