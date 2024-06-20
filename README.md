# Jenkins Docker Slave

This Docker image is based on the `jenkins/slave:4.13.3-2-alpine` image and includes additional tools and dependencies for building and testing Java, Gradle, and Maven projects, as well as for running Node.js applications and API testing with Dredd and Newman.

## Installed Tools

- Docker
- Gradle 8.8
- Maven 3.9.8
- Python 3 with `virtualenv`
- Node.js with npm
- OpenJDK 11
- Dredd
- Newman
- newman-reporter-htmlextra

## Usage

To use this Docker image, you can pull it from Docker Hub:

```sh
docker pull musanmaz/jenkins-slave:latest
```

## Setting Up Jenkins to Use This Docker Image as a Build Agent

1. #### Install the Docker Plugin for Jenkins

    Ensure that the Docker plugin is installed in your Jenkins instance. You can install it from the Jenkins plugin manager.

2. #### Configure Jenkins to Use Docker Agent

    - Navigate to `Manage Jenkins` -> `Configure System`.

    - Scroll down to `Cloud` and click `Add a new cloud` -> `Docker`.

3. #### Add Docker Cloud Details

    - Docker URL: `unix:///var/run/docker.sock`

    - Enabled: Check this option.

4. #### Add Docker Agent Template

    - Click `Add Docker Template`.

    - Fill in the following details:

        - Labels: `docker-slave`

        - Name: `jenkins-slave`

        - Docker Image: `musanmaz/jenkins-slave:latest`

        - Remote File System Root: `/home/jenkins`

        - Instance Capacity: `1`

5. #### Configure Advanced Settings

    - Connect Method: `Connect with SSH`

    - Host Key Verification Strategy: `Non verifying Verification Strategy`
    - Add SSH Credentials:

        - Click `Add` -> `Jenkins` -> `SSH Username with private key`

        - Username: `jenkins`

        - Private Key: Enter the private key here or select the appropriate method to provide the key.

6. #### Save the Configuration

## Using the Docker Agent in Your Jenkins Pipeline

You can use the configured Docker agent in your Jenkins pipeline scripts by specifying the `docker-slave` label. Here is an example of a Jenkins pipeline script:

``` groovy
pipeline {
    agent {
        label 'docker-slave'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    // Your build steps here
                    sh 'gradle build'
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    // Your test steps here
                    sh 'mvn test'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Your deploy steps here
                    sh 'docker build -t myapp:latest .'
                    sh 'docker push myapp:latest'
                }
            }
        }
    }
}
```