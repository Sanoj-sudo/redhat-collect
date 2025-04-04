FROM jenkins/jenkins:lts

# Switch to root user
USER root

# Install system dependencies for RPM packaging
RUN dnf install -y sudo rpm-build rpmdevtools && \
    dnf clean all

# Allow Jenkins to use sudo without a password
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins

# Disable Jenkins setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Ensure Jenkins init directory exists
RUN mkdir -p /var/jenkins_home/init.groovy.d

# Copy security settings and init scripts
COPY security.groovy /var/jenkins_home/init.groovy.d/security.groovy
COPY init.groovy /var/jenkins_home/init.groovy.d/init.groovy

# Install default plugins
COPY jenkins_plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt

# Ensure Jenkins jobs directory exists
RUN mkdir -p /var/jenkins_home/jobs/collect

# Copy preconfigured job
COPY config.xml /var/jenkins_home/jobs/collect/config.xml

# Copy pipeline definition
COPY Jenkinsfile /var/jenkins_home/Jenkinsfile

# Install Go and gum for the script
RUN curl -LO https://go.dev/dl/go1.23.8.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.23.8.linux-amd64.tar.gz && \
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile && \
    source /etc/profile && \
    go version && \
    go install github.com/charmbracelet/gum@latest && \
    echo 'export PATH=$PATH:/usr/local/bin' >> /etc/profile && \
    source /etc/profile && \
    which gum

# Copy the shell script to be packaged
COPY my_script.sh /var/jenkins_home/redhat.sh
RUN chmod +x /var/jenkins_home/redhat.sh

# Ensure Jenkins has proper permissions
RUN chown -R jenkins:jenkins /var/jenkins_home/jobs /var/jenkins_home/redhat.sh

# Switch back to Jenkins user
USER jenkins

# Expose Jenkins port
EXPOSE 8080

# Start Jenkins
CMD ["/usr/local/bin/jenkins.sh"]
