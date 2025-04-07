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
                    SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt update -y 
                    SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt install dpkg-dev rpm curl tar -y
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

                    GUM_RPM_URL="https://github.com/charmbracelet/gum/releases/download/v0.16.0/gum-0.16.0-1.x86_64.rpm"
                    echo "⬇️ Downloading pre-built Gum RPM from: $GUM_RPM_URL"
                    curl -f -m 30 -sS --retry 3 "$GUM_RPM_URL" -o gum.rpm

                    if [ -f "gum.rpm" ]; then
                        echo "✅ Gum RPM downloaded successfully."

                        # Extract the gum binary from the RPM (without installing system-wide)
                        rpm2cpio gum.rpm | cpio -idv ./usr/bin/gum ./usr/local/bin/gum # Check common install paths

                        # Move the extracted binary to the desired location in your build
                        if [ -f "./usr/bin/gum" ]; then
                            mv ./usr/bin/gum rpm_build/usr/local/bin/gum
                        elif [ -f "./usr/local/bin/gum" ]; then
                            mv ./usr/local/bin/gum rpm_build/usr/local/bin/gum
                        else
                            echo "⚠️ Warning: gum binary not found in expected RPM paths."
                            exit 1
                        fi
                        chmod +x rpm_build/usr/local/bin/gum

                        echo "📦 Preparing sources..."
                        cp collect_data.sh rpm_build/SOURCES/
                        cp myscript.spec rpm_build/SPECS/collect-info.spec
                        chmod +x rpm_build/SOURCES/collect_data.sh

                        rpmbuild --define "_topdir $(pwd)/rpm_build" -bb rpm_build/SPECS/collect-info.spec
                    else
                        echo "❌ Error: Failed to download Gum RPM."
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