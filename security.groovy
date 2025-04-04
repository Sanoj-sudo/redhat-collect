#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

// Create a new security realm
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount("admin", "admin@123")  // Change username & password here
instance.setSecurityRealm(hudsonRealm)

// Assign full permissions to the admin user
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)  // Disable anonymous access
instance.setAuthorizationStrategy(strategy)

instance.save()
