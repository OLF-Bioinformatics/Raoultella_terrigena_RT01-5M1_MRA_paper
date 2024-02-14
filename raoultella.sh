#!/bin/bash

# Performance
export cpu=$(nproc)
export maxProc=1
export prog=$HOME/prog
export scripts=$HOME/scripts
export mem=$(($(grep MemTotal /proc/meminfo | awk '{print $2}')*85/100000000)) #85% of total memory in GB
export memJava="-Xmx"$mem"g" 

# Refseq masher

genome='/home/bioinfo/analyses/raoultella/short_read_polish_5000/polished_illumina/BB5M1.fasta'

function id_sample() {
    sample=$(basename "$1" ".fasta")
    refseq_masher matches\
        --output-type "tab" \
        -n 1 \
        -m 1 \
        $1 \
        | sed -n 2p >> '/home/bioinfo/analyses/raoultella/refseq_masher/refseq_masher_ids.tsv';
}

echo -e "sample\ttop_taxonomy_name\tdistance\tpvalue\tmatching\tfull_taxonomy\ttaxonomic_species\ttaxonomic_genus\ttaxonomic_family\ttaxonomic_order\ttaxonomic_class\ttaxonomic_phylum\ttaxonomic_superkingdom\tsubspecies\tserovar\tplasmid\tbioproject\tbiosample\ttaxid\tassembly_accession\tmatch_id"     > /home/bioinfo/analyses/raoultella/refseq_masher/refseq_masher_ids.tsv

conda activate refseq_masher
id_sample "$genome" 
conda deactivate

# mashID

conda activate mashID

python ~/prog/mashID/mashID.py \
    -d /media/36tb/db/mashID/2023-01-19_refseq_bacteria_derep_0.01.msh \
    -i "$genome" \
    -o /home/bioinfo/analyses/raoultella/mashID \
    -p 1

genus=Raoultella
species=terrigena

# PGAP version 2023-10-03.build7061
annotation=/home/bioinfo/analyses/raoultella/annotation

[ -d "${annotation}"/pgap ] || mkdir -p "${annotation}"/pgap

function annotate_pgap()
{
    sample=$(basename "$1" ".fasta")
    file_name=$(basename "$1")

    input_dir=$(dirname "$1")
    out_dir="${annotation}"/pgap/"$sample" 

    input_yaml="${sample}"_inputs.yaml
    metadata_yaml="${sample}"_metadata.yaml

    cd "${annotation}"/pgap

    # 3 files (1 fasta and 2 yaml) need to be in same folder
    cp "$1" "${annotation}"/pgap

    # Create yaml file for input files
    echo -n "\
fasta: 
    class: File
    location: "$file_name" 
submol:
    class: File
    location: "$metadata_yaml" 
" > "$input_yaml" 

    # Create yaml file for sample metadata
    echo -n "\
organism:
    genus_species: '"$genus" "$species"'
    strain: 'my_strain'
" > "$metadata_yaml" 

    # Run PGAP v2023-10-03.build7061
    python "${prog}"/pgap.py \
        --no-self-update \
        --report-usage-false \
        --ignore-all-errors \
        --auto-correct-tax \
        --cpus "$cpu" \
        --memory "${mem}"g \
        --output "$out_dir" \
        "$input_yaml" 

    # Cleanup?
    # rm "${annotation}"/pgap/"$file_name" 
}

annotate_pgap "$genome" 

####  AMR

amr=/home/bioinfo/analyses/raoultella/amr

### Resfinder
conda activate resfinder

function run_resfinder ()
{
    # https://bitbucket.org/genomicepidemiology/resfinder/overview
    sample=$(basename "$1" ".fasta")

    [ -d "${amr}"/resfinder/"${ass}"/"$sample" ] || mkdir -p "${amr}"/resfinder/"${ass}"/"$sample" 

    # Run resfinder v4.1.5
    python3 "${prog}"/resfinder/run_resfinder.py \
        -ifa "$1" \
        -o "${amr}"/resfinder/"${ass}"/"$sample" \
        -db_res_kma "${prog}"/resfinder/resfinder_db/ \
        -t 0.9 \
        -l 0.6 \
        -acq
        # 1> >(tee "${amr}"/resfinder/"${sample}"/"${sample}"_resfinder.txt)

    rm -rf "${amr}"/resfinder/"${ass}"/"${sample}"/tmp
}

run_resfinder $genome

# Create merged report
echo -e 'Sample\tResistance gene\tIdentity\tAlignment Length/Gene Length\tCoverage\tPosition in reference\tContig\tPosition in contig\tPhenotype\tAccession no.' \
    > "${amr}"/resfinder/"${ass}"/resfinder_merged.tsv.tmp

for i in $(find "${amr}"/resfinder/"$ass" -name "*results_tab.txt"); do
    # sample name is folder name
    sample=$(basename $(dirname "$i"))
    sample="${sample%.fasta}" 

    # Add a leading column with sample name
    cat "$i" \
        | sed -e '1d' \
        | awk -F $'\t' -v s="$sample" 'BEGIN {OFS = FS} {print s,$0}' \
        >> "${amr}"/resfinder/"${ass}"/resfinder_merged.tsv.tmp
done

# sort by sample name (column 1), then by Identity (column 3)
(cat "${amr}"/resfinder/"${ass}"/resfinder_merged.tsv.tmp | head -n 1;
    cat "${amr}"/resfinder/"${ass}"/resfinder_merged.tsv.tmp | sed -e '1d' | sort -t $'\t' -k1,1 -k3,3) \
    > "${amr}"/resfinder/"${ass}"/resfinder_merged.tsv

rm "${amr}"/resfinder/"${ass}"/resfinder_merged.tsv.tmp

conda deactivate

### RGI (CARD)
conda activate rgi

function run_rgi()
{
    sample=$(basename "$1" ".fasta")

    [ -d "${amr}"/rgi/"${ass}"/"$sample" ] || mkdir -p "${amr}"/rgi/"${ass}"/"$sample" 

    # Run rgi v5.2.0
    rgi main \
        -i "$1" \
        -o  "${amr}"/rgi/"${ass}"/"${sample}"/"$sample" \
        -t 'contig' \
        -a 'BLAST' \
        -n $((cpu/maxProc)) \
        --clean \
        -d "chromosome" 
}

run_rgi $genome

# Create merged report
echo -e 'Sample\tORF_ID\tContig\tStart\tStop\tOrientation\tCut_Off\tPass_Bitscore\tBest_Hit_Bitscore\tBest_Hit_ARO\tBest_Identities\tARO\tModel_typeSNPs_in_Best_Hit_ARO\tOther_SNPs\tDrug\tClass\tResistance\tMechanism\tAMR\tGene\tFamily\tPredicted_DNA\tPredicted_Protein\tCARD_Protein_Sequence\tPercentage_Length_of_Reference_Sequence\tID\tModel_ID' \
    > "${amr}"/rgi/"${ass}"/rgi_merged.tsv.tmp

for i in $(find "${amr}"/rgi/"${ass}" -name "*.txt"); do
    # sample name is folder name
    sample=$(basename $(dirname "$i"))
    sample="${sample%.fasta}" 

    # Add a leading column with sample name
    cat "$i" \
        | sed -e '1d' \
        | awk -F $'\t' -v s="$sample" 'BEGIN {OFS = FS} {print s,$0}' \
        >> "${amr}"/rgi/"${ass}"/rgi_merged.tsv.tmp
done

# sort by Sample name (column 1), then by Cutt_off (column 7)
(cat "${amr}"/rgi/"${ass}"/rgi_merged.tsv.tmp | head -n 1;
    cat "${amr}"/rgi/"${ass}"/rgi_merged.tsv.tmp | sed -e '1d' | sort -t $'\t' -k1,1 -k7,7) \
    > "${amr}"/rgi/"${ass}"/rgi_merged.tsv

rm "${amr}"/rgi/"${ass}"/rgi_merged.tsv.tmp

conda deactivate
