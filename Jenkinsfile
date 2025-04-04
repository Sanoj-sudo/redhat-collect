pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Sanoj-sudo/redhat-collect.git'
            }
        }

        stage('Setup Environment') {
            steps {
                sh 'SUDO_ASKPASS=/etc/askpass-jenkins.sh sudo -A apt update && sudo -A apt install dpkg-dev rpm -y'
            }
        }

        stage('Build RPM Package') {
            steps {
                sh 'echo "Starting RPM build process..."'
                sh 'which rpmbuild || echo "rpmbuild not found!"'

                // Create necessary RPM directories using bash for brace expansion
                sh '''#!/bin/bash
                    mkdir -p rpm_package/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
                    mkdir -p rpm_package/usr/local/bin
                '''

                // Copy the shell script to SOURCES
                sh 'cp collect_data.sh rpm_package/SOURCES/'
                sh 'chmod +x rpm_package/SOURCES/collect_data.sh'

                // Create the RPM SPEC file
                sh '''cat <<EOF > rpm_package/SPECS/collect-info.spec
Name: collect-info
Version: 1.0
Release: 1%{?dist}
Summary: A script that collects system information using gum UI.
License: GPL
BuildArch: noarch

%description
A script that collects system information using gum UI.

%prep
%setup -q

%build

%install
mkdir -p %{buildroot}/usr/local/bin
cp %{_sourcedir}/collect_data.sh %{buildroot}/usr/local/bin/
chmod +x %{buildroot}/usr/local/bin/collect_data.sh

%files
/usr/local/bin/collect_data.sh

%changelog
* Fri Apr 5 2024 Sanoj <sanojkumar715@email.com> - 1.0-1
- Initial RPM release
EOF
'''

                // Build the RPM package
                sh 'echo "Running rpmbuild..."'
                sh 'rpmbuild --define "_topdir $(pwd)/rpm_package" -bb rpm_package/SPECS/collect-info.spec'
            }
        }

        stage('Archive Packages') {
            steps {
                archiveArtifacts artifacts: 'rpm_package/RPMS/noarch/collect-info-1.0-1.noarch.rpm', fingerprint: true
            }
        }
    }
}
