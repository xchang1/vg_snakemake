# Prefetch the data for one accession from sra
#rule prefetch_sra:
#    output:
#        sra='results/{sample}/{sample}.sra'
#    threads: 1
#    resources:
#        mem_mb=100,
#        runtime=20
#    container: docker_imgs['sra-tools']
#    shell:
#        """
#        prefetch {wildcards.sample} -O results/
#        """

# Get the reads from SRA
rule fasterq_dump_sra:
    input:
        sra='results/{sample}/{sample}.sra'
    output:
        fq1=temp('results/{sample}/{sample}.1.fastq'),
        fq2=temp('results/{sample}/{sample}.2.fastq')
    threads: 1
    resources:
        mem_mb=800,
        runtime=30
    shell:
        """
        fasterq-dump {wildcards.sample} --outdir results/{wildcards.sample}
        mv results/{wildcards.sample}/{wildcards.sample}_1.fastq {output.fq1}
        mv results/{wildcards.sample}/{wildcards.sample}_2.fastq {output.fq2}
        """

# Get the reads from SRA
rule gzip_reads:
    input:
        fq='results/{sample}/{sample}.{pair}.fastq',
    output:
        fq=temp('results/{sample}/{sample}.{pair}.fastq.gz'),
    threads: 1
    resources:
        mem_mb=20,
        runtime=30
    shell:
        """
        gzip {input.fq}
        """
