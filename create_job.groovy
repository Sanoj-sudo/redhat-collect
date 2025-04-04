import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.*

def instance = Jenkins.getInstance()

println "--> Creating pipeline job 'rpm-job'"

def job = new WorkflowJob(instance, "rpm-job")
job.setDefinition(new org.jenkinsci.plugins.workflow.cps.CpsFlowDefinition(
    new File("/var/jenkins_home/jobs/rpm-job-pipeline.groovy").text, true
))
instance.reload()
