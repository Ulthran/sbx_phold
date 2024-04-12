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
            VIRUS_FP / "phold" / "{sample}" / "phold.gbk",
            sample=Samples.keys()
        )


rule install_phold_database:
    output:
        db=Cfg["sbx_phold"]["phold_db"]
    conda:
        "envs/sbx_phold_env.yml"
    container:
        "docker://sunbeamlabs/sbx_phold"
    shell:
        """
        phold install --database {output.db}
        """


rule phold_predict:
    input:
        contigs=ASSEMBLY_FP / "megahit" / "{sample}_asm" / "final.contigs.fa",
        db=rules.install_phold_database.output.db
    output:
        cds=VIRUS_FP / "phold" / "{sample}" / "phold_per_cds_predictions.tsv",
    conda:
        "envs/sbx_phold_env.yml"
    container:
        "docker://sunbeamlabs/sbx_phold"
    shell:
        """
        phold predict -i {input.contigs} -o $(dirname {output.cds}) --database {input.db} --cpu --force
        """

rule phold_compare:
    input:
        contigs=ASSEMBLY_FP / "megahit" / "{sample}_asm" / "final.contigs.fa",
        cds=VIRUS_FP / "phold" / "{sample}" / "phold_per_cds_predictions.tsv",
    output:
        gbk=VIRUS_FP / "phold" / "{sample}" / "phold.gbk",
    conda:
        "envs/sbx_phold_env.yml"
    container:
        "docker://sunbeamlabs/sbx_phold"
    shell:
        """
        phold compare -i {input.contigs} --predictions_dir $(dirname {input.cds}) -o $(dirname {output.gbk}) -t 8
        """
