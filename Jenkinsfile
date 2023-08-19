node('python') {
    def application = "pythonapp"
    def dockerhubaccountid = "harsha4143"
    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        app = docker.build("${dockerhubaccountid}/${application}:${BUILD_NUMBER}")
    }

    stage('Clean Up') {
    
        
            sh returnStatus: true, script: "docker stop $(docker ps -a | grep -i ${JOB_NAME} | awk '{print $1}')"
            sh returnStatus: true, script: "docker rmi $(docker images | grep ${dockerhubaccountid} | awk '{print $3}') --force"
            sh returnStatus: true, script: "docker rm ${JOB_NAME}"
        
    
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
        sh("docker rmi ${dockerhubaccountid}/${application}:latest -f")
   }
}
