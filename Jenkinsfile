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
                    SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt install dpkg-dev rpm curl tar gzip file -y
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

                    GUM_VERSION="0.12.1" # Use a specific Gum version
                    GUM_URL="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_Linux_x86_64.tar.gz"
                    echo "⬇️ Downloading gum binary (version ${GUM_VERSION}) from: $GUM_URL"
                    if curl -f -m 30 -sS --retry 3 "$GUM_URL" -o gum.tar.gz; then
                      echo "✅ Gum binary downloaded successfully."
                      FILE_SIZE=$(du -b gum.tar.gz | awk '{print $1}')
                      if [ "$FILE_SIZE" -gt 0 ]; then
                        echo "📦 Downloaded file size: ${FILE_SIZE} bytes."
                        file gum.tar.gz # Check the file type
                        if [[ $(file -b --mime-type gum.tar.gz) == "application/gzip" ]]; then
                          tar -xzf gum.tar.gz
                          mv gum rpm_build/usr/local/bin/gum
                          chmod +x rpm_build/usr/local/bin/gum

                          echo "📦 Preparing sources..."
                          cp collect_data.sh rpm_build/SOURCES/
                          cp myscript.spec rpm_build/SPECS/collect-info.spec
                          chmod +x rpm_build/SOURCES/collect_data.sh

                          rpmbuild --define "_topdir $(pwd)/rpm_build" -bb rpm_build/SPECS/collect-info.spec
                        else
                          echo "ERROR: Downloaded file is not a gzip archive!"
                          exit 1
                        fi
                      else
                        echo "ERROR: Downloaded file is empty!"
                        exit 1
                      fi
                    else
                      echo "ERROR: Failed to download gum binary."
                      exit 1
                    fi
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