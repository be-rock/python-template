#!/usr/bin/env groovy

pipeline {
    agent any
    // agent { label 'linux' }

    environment {
        VIRTUAL_ENV = "${env.WORKSPACE}/.venv"
    }

    stages {

        stage ('setup') {
            steps {
                sh """
                    make clean
                    make cicd
                """
            }
        }

        stage ('tests') {
            steps {
                sh """
                    make test || true
                """
            }
        }

    } // stages

    post {
        always {
            deleteDir() // clean up the workspace directory
        }
        // failure {
        // }

        // success {
        // }
    }
}
