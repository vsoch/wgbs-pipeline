task dinosaur {
  String singularity_container = "shub://vsoch/hello-world"
  output {
    String roar = read_string(stdout())
  }
  command {
    singularity --silent \
    run \
    ${singularity_container}
  }
}

workflow wf_hello {
  call dinosaur
  output {
     dinosaur.roar
  }
}
