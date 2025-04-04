import jenkins.model.*
import hudson.util.*

def instance = Jenkins.getInstance()

println "--> Configuring Jenkins default plugins"

def plugins = [
    "cloudbees-folder",
    "antisamy-markup-formatter",
    "build-timeout",
    "credentials-binding",
    "timestamper",
    "ws-cleanup",
    "ant",
    "gradle",
    "pipeline-github-lib",
    "github-branch-source",
    "pipeline-graph-view",
    "git",
    "ssh-slaves",
    "matrix-auth",
    "pam-auth",
    "ldap",
    "email-ext",
    "mailer",
    "dark-theme"
]

def updateCenter = instance.getUpdateCenter()
def pm = instance.getPluginManager()

plugins.each { plugin ->
    if (!pm.getPlugin(plugin)) {
        println "--> Installing: ${plugin}"
        updateCenter.getPlugin(plugin).deploy().get()
    }
}

println "--> Plugin installation complete"
instance.save()