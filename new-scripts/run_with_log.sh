log_parent_folder=logs

timestamp=$(date +"%Y%m%d_%H%M%S")

log_folder="$log_parent_folder/$timestamp"

mkdir -p "$log_folder"

mode="exp"

model_conds=(
    "model.200.10000000.0.0000001"
    "model.200.10000000.0.000001"
    "model.200.2000000.0.000001"
    "model.200.2000000.0.0000001"
    "model.200.500000.0.000001"
    "model.200.500000.0.0000001"
)

vanilla_jar_path="jars/wqfm-tree-vanilla-bug-fixed.jar"

# for model_cond in "${model_conds[@]}"; do
#     bash new-scripts/runAstral2DatasetsEst.sh ../astral2Cleaned "$model_cond" $mode 01 02 03 04 05 06 07 08 09 10 > "$log_folder/output.log" 2> "$log_folder/err.err"
# done

for model_cond in "${model_conds[@]}"; do
    log_output="$log_folder/output-$model_cond.log"
    log_err="$log_folder/err-$model_cond.err"
    echo "Running model condition: $model_cond"
    bash new-scripts/runDataset.sh ../astral2Cleaned "$model_cond" wqfm-tree-og \
    "$vanilla_jar_path" 01 02 03 04 05 06 07 08 09 10 > "$log_output" 2> "$log_err"
done