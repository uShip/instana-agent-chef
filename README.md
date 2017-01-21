# instana-agent Cookbook

This cookbook installs the agent for the Instana, Inc.(tm) monitoring suite.

## Requirements

* [Oracle Java](https://www.oracle.com/java/index.html) JDK >= 8.

    Even though the Instana agent might run under different environments (e.g.
    [icedtea](http://icedtea.classpath.org/wiki/Main_Page)), we do not support such environments.

## Flavors

**`instana-agent-full`** 

    It comes with a prebundled JDK. Also it includes the latest version of all the sensors in
    their latest version so that firewalls in tight onprem networks do not have to pull them
    the first time the agent starts.

**`instana-agent-minimal`**

    It comes with neither the JDK nor sensors bundled. Upon startup, it connects to our agent 
    artifact repository to download all the sensors. If you use this one, a `JAVA_HOME` path 
    needs to be specified.

### Attributes

* **(Required)** `node.default['instana']['agent']['flavor']` = (string) Either "minimal" or "full"
* **(Required)** `node.default['instana']['agent']['agentKey']` = (string) Your tenancy agent key


* **(Optional)** `node.default['instana']['agent']['hostTags']` = (array) List of host-tag strings 
* **(Optional)** `node.default['instana']['agent']['jdk']` = (minimal bundle) Path of your JDK install 

## License and Authors

* [Stefan Staudenmeyer](mailto:stefan.staudenmeyer@instana.com "Stefan Staudenmeyer")


    Copyright 2016, INSTANA Inc (All rights reserved)
