process DEEPTOOLS_PLOTPROFILE {
    tag "$meta.id"
    label 'process_low'

    conda 'modules/nf-core/deeptools/plotprofile/environment.yml'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/deeptools:3.5.1--py_0' :
        'biocontainers/deeptools:3.5.1--py_0' }"

    input:
    tuple val(meta), path(matrix)

    output:
    tuple val(meta), path("*.pdf"), emit: pdf
    tuple val(meta), path("*.tab"), emit: table
    path  "versions.yml"          , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    plotProfile \\
        $args \\
        --matrixFile $matrix \\
        --outFileName ${prefix}.plotProfile.pdf \\
        --outFileNameData ${prefix}.plotProfile.tab

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        deeptools: \$(plotProfile --version | sed -e "s/plotProfile //g")
    END_VERSIONS
    """
}
