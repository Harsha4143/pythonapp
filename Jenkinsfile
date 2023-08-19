node('python') {
    def application = "pythonapp"
    def dockerhubaccountid = "harsha4143"
    stage('Clone repository') {
        checkout scm
    }
    stage('Clean Up') {
   
        
            sh returnStatus: true, script: "docker stop \$(docker ps -a | grep ${application} | awk '{print \$1}')"
            sh returnStatus: true, script: "docker rmi \$(docker images | grep -iE '${dockerhubaccountid}|none|python' | awk '{print \$3}') --force"
            sh returnStatus: true, script: "docker rm \$(docker ps -a | grep -iE 'Exited|Created' | awk 'NR>1 {print \$1}')"
       
   
}

    stage('Build image') {
        app = docker.build("${dockerhubaccountid}/${application}:${BUILD_NUMBER}")
    }

   

    stage('Push image') {
        withDockerRegistry([ credentialsId: "dockerHub", url: "" ]) {
        app.push()
        app.push("latest")
    }
    }

    stage('Deploy') {
        sh ("docker run -d -p 3333:3333 ${dockerhubaccountid}/${application}:${BUILD_NUMBER}")
    }

   stage('Remove old images') {
        // remove old docker images
       script {

        sh("docker rmi ${dockerhubaccountid}/${application}:latest -f")
       }
   }
}
