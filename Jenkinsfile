pipeline {
    agent any

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sanoj-sudo/redhat-collect.git'
            }
        }

        stage('Setup Environment') {
            steps {
                sh '''
                    echo "🔧 Updating system and installing dependencies..."
                    SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt update
                    SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt install dpkg-dev rpm -y
                '''
            }
        }

        stage('Build RPM Package') {
            steps {
                sh 'echo "🚀 Starting RPM build process..."'
                sh 'which rpmbuild || echo "⚠️ rpmbuild not found!"'

                sh '''#!/bin/bash
                    set -e
                    mkdir -p rpm_build/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
                    mkdir -p rpm_build/usr/local/bin

                    cp collect_data.sh rpm_build/SOURCES/
                    cp myscript.spec rpm_build/SPECS/collect-info.spec
                    chmod +x rpm_build/SOURCES/collect_data.sh

                    rpmbuild --define "_topdir $(pwd)/rpm_build" -bb rpm_build/SPECS/collect-info.spec
                '''
            }
        }

        stage('Archive Packages') {
            steps {
                archiveArtifacts artifacts: 'rpm_build/RPMS/noarch/*.rpm', fingerprint: true
            }
        }
    }
}
