## DevOps Exam PGR301

## Exam Fall 2018

## Concourse + Terraform

# How to run?
# Go into root folder in exam-infra and type all commands from there

#####1
- make a concourse server
    - fly -t devExam login --concourse-url http://127.0.0.1:8080 -u admin -p admin

#####2    
- set pipeline
   - fly -t devExam sp -c concourse/pipeline.yml -p ci+terraform -l credentials.yml
   - choose 'y' and press enter
   
   
#####3
- enter url -> http://127.0.0.1:8080/teams/main/pipelines/ci+terraform
    - enter username: admin, password: admin
    
    
####4
- unpause pipeline
    - fly -t devExam unpause-pipeline -p ci+terraform
    
    



