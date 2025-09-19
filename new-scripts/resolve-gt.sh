root="../astral2Cleaned"


gtFolderPath="$root/estimated-gene-trees"

gt_file_name=gt-cleaned
resolved=gt-cleaned-resolved


    # model.200.10000000.0.0000001
    # model.200.2000000.0.000001
    # model.200.10000000.0.000001	
    # model.200.2000000.0.0000001

model_conds_to_run=(	
    model.200.500000.0.0000001
    model.200.500000.0.000001
)

for model_cond in "${model_conds_to_run[@]}"
do
    echo "Resolving polytomies for model condition: $model_cond"
    current_gtFolderPath=$gtFolderPath/$model_cond

    for file in $(ls $current_gtFolderPath)
    do
        echo "Running for model condition: $model_cond, dataset: $file"
        python3 ./scripts/arb_resolve_polytomies.py $current_gtFolderPath/$file/$gt_file_name
        python3 ./scripts/treeCleaner.py < $current_gtFolderPath/$file/$gt_file_name.resolved > $current_gtFolderPath/$file/$resolved
           
    done
done
