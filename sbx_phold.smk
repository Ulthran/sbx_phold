def get_phold_path() -> Path:
    for fp in sys.path:
        if fp.split("/")[-1] == "sbx_phold":
            return Path(fp)
    raise Error(
        "Filepath for sbx_phold not found, are you sure it's installed under extensions/sbx_phold?"
    )


SBX_PHOLD_VERSION = open(get_phold_path() / "VERSION").read().strip()

try:
    BENCHMARK_FP
except NameError:
    BENCHMARK_FP = output_subdir(Cfg, "benchmarks")
try:
    LOG_FP
except NameError:
    LOG_FP = output_subdir(Cfg, "logs")


localrules:
    all_template,


rule all_phold:
    input:
        expand(
            VIRUS_FP / "phold" / "{sample}_compare" / "phold.gbk",
            sample=Samples.keys(),
        ),
        #expand(VIRUS_FP / "phold" / "{sample}_plot" / "{sample}.png", sample=Samples.keys()),


rule install_phold_database:
    output:
        annotations=Path(Cfg["sbx_phold"]["phold_db"]) / "phold_annots.tsv",
    conda:
        "envs/sbx_phold_env.yml"
    container:
        "docker://sunbeamlabs/sbx_phold"
    shell:
        """
        phold install --database $(dirname {output.annotations})
        """


rule phold_predict:
    input:
        contigs=ASSEMBLY_FP / "megahit" / "{sample}_asm" / "final.contigs.fa",
        annotations=Path(Cfg["sbx_phold"]["phold_db"]) / "phold_annots.tsv",
    output:
        _3di=VIRUS_FP / "phold" / "{sample}_predict" / "phold_3di.fasta",
    conda:
        "envs/sbx_phold_env.yml"
    container:
        "docker://sunbeamlabs/sbx_phold"
    shell:
        """
        if [ ! -s {input.contigs} ]; then
            touch {output._3di}
        else
            phold predict -i {input.contigs} -o $(dirname {output._3di}) --database $(dirname {input.annotations}) --cpu --force
        fi
        """


rule phold_compare:
    input:
        contigs=ASSEMBLY_FP / "megahit" / "{sample}_asm" / "final.contigs.fa",
        _3di=VIRUS_FP / "phold" / "{sample}_predict" / "phold_3di.fasta",
        annotations=Path(Cfg["sbx_phold"]["phold_db"]) / "phold_annots.tsv",
    output:
        gbk=VIRUS_FP / "phold" / "{sample}_compare" / "phold.gbk",
    conda:
        "envs/sbx_phold_env.yml"
    container:
        "docker://sunbeamlabs/sbx_phold"
    threads: 8
    shell:
        """
        if [ ! -s {input._3di} ]; then
            touch {output.gbk}
        else
            phold compare -i {input.contigs} --predictions_dir $(dirname {input._3di}) -o $(dirname {output.gbk}) --database $(dirname {input.annotations}) -t 8 --force
        fi
        """


rule phold_plot:
    input:
        gbk=VIRUS_FP / "phold" / "{sample}_compare" / "phold.gbk",
    output:
        png=VIRUS_FP / "phold" / "{sample}_plot" / "{sample}.png",
    conda:
        "envs/sbx_phold_env.yml"
    container:
        "docker://sunbeamlabs/sbx_phold"
    shell:
        """
        if [ ! -s {input.gbk} ]; then
            touch {output.png}
        else
            phold plot -i {input.gbk} -o $(dirname {output.png}) --force
        fi
        """
