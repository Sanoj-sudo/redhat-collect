FROM jenkins/jenkins:lts

# Switch to root user
USER root

# Install system dependencies for building RPM and DEB packages
RUN apt-get update && \
    apt-get install -y sudo rpm dpkg-dev build-essential fakeroot && \
    apt-get clean

# Allow Jenkins to use sudo without a password
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins

# Disable setup wizard
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

# Set correct permissions
RUN chown -R jenkins:jenkins /var/jenkins_home/jobs

# Create RPM build directories (optional)
RUN mkdir -p /home/jenkins/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS} && \
    chown -R jenkins:jenkins /home/jenkins/rpmbuild

# Switch back to Jenkins user
USER jenkins

# Expose Jenkins port
EXPOSE 8080

# Start Jenkins
CMD ["/usr/local/bin/jenkins.sh"]
