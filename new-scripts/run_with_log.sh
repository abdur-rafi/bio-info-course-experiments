log_parent_folder=logs

timestamp=$(date +"%Y%m%d_%H%M%S")

log_folder="$log_parent_folder/$timestamp"

mkdir -p "$log_folder"

mode="exp"


    # "model.200.2000000.0.000001"
    # "model.200.2000000.0.0000001"
    # "model.200.500000.0.000001"
    # "model.200.500000.0.0000001"
    # "model.200.10000000.0.000001"
    # "model.200.10000000.0.0000001"
model_conds=(
    "model.200.2000000.0.000001"
    "model.500.2000000.0.000001"
)

vanilla_jar_path="jars/wqfm-tree-vanilla-bug-fixed.jar"
merged_input_transfer_optimized="jars/merge-input-optimized-transfer.jar"
reuse_object="jars/wqfm-tree-reuse-objects.jar"
astral_jar="jars/astral.5.7.8.jar"
remove_partition_jar="jars/remove-freq-1-partitions.jar"


vanilla_output="wqfm-tree-og"
merged_input_transfer_optimized_output="wqfm-tree-mito"
reuse_object_output="wqfm-tree-ro"
astral_output="astral3"
remove_partition_output="wqfm-tree-rmp"

# for model_cond in "${model_conds[@]}"; do
#     bash new-scripts/runAstral2DatasetsEst.sh ../astral2Cleaned "$model_cond" $mode 01 02 03 04 05 06 07 08 09 10 > "$log_folder/output.log" 2> "$log_folder/err.err"
# done

for model_cond in "${model_conds[@]}"; do
    log_output="$log_folder/output-$model_cond.log"
    log_err="$log_folder/err-$model_cond.err"
    echo "Running model condition: $model_cond"

    # bash new-scripts/runDataset.sh ../astral2 "$model_cond" "$vanilla_output" \
    # "$vanilla_jar_path" $timestamp 01 02 03 04 05 06 07 08 09 10 > "$log_output" 2> "$log_err"

    # bash new-scripts/runDataset_Astral.sh ../astral2 "$model_cond" "$astral_output" \
    # "$astral_jar" "$timestamp" 01 02 03 04 05 06 07 08 09 10 > "$log_output" 2> "$log_err"


    # bash new-scripts/runDataset.sh ../astral2 "$model_cond" "$reuse_object_output" \
    # "$reuse_object" $timestamp 01 02 03 04 05 06 07 08 09 10 > "$log_output" 2> "$log_err"

    bash new-scripts/runDataset.sh ../astral2 "$model_cond" "$remove_partition_output" \
    "$remove_partition_jar" $timestamp 01 02 03 04 05 06 07 08 09 10 > "$log_output" 2> "$log_err"
done