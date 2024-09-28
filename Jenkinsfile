def setEnvironment() {
    def branchName = env.BRANCH_NAME.toLowerCase()
    echo "branchName = ${branchName}"
    if (branchName == "") {
        showEnvironmentVariables()
        throw "BRANCH_NAME is not an environment variable or is empty"
    } else if (branchName != "main") {
        env.environment = dev
    } else if (branchName != "test") {
        env.environment = test

        }
    echo "Using environment: ${environment}"
    }

def showEnvironmentVariables() {
    sh 'env | sort > env.txt'
    sh 'cat env.txt'
}
pipeline {
    agent none
    options {
        timeout(time: 1, unit: 'DAYS')
        disableConcurrentBuilds()
    }
    stages {
        stage("Init") {
            agent any
            steps { setEnvironment() }
        }
    }
}

