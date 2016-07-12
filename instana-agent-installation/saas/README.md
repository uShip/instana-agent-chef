# instana-agent Cookbook

This cookbook installs the Instana agent.

## Requirements

* [Oracle Java](https://www.oracle.com/java/index.html) JDK >= 8.

Even though the Instana agent might run under different environments (e.g.
[icedtea](http://icedtea.classpath.org/wiki/Main_Page)), we do not support such
environments.

### Recipes

* `check_java`: Checks the java environment, prints warnings if its not an Oracle(tm) JDK v8
* `default`: Includes the recipes `check_java`, `download` & `install`
* `download`: Downloads the Instana agent archive
* `install`: Installs the Instana agent to said directory (see Attributes)
* `run`: Runs the Instana agent

### Attributes

* `node.default['instana']['tenant']['name']` = 'Your Tenant Unit name'
* `node.default['instana']['tenant']['unit']` = 'Your Tenant name'
* `node.default['instana']['tenant']['email']` = 'Your Email address'
* `node.default['instana']['tenant']['password']` = 'Your Password'
* `node.default['instana']['tenant']['agentSrc']` = 'Where the temp. archive should go'
* `node.default['instana']['tenant']['agentDest']` = 'Where the agent should go'
* **(Optional)** `node.default['javaloc']` = 'Path of your JDK install'

## License and Authors

* [Stefan Staudenmeyer](mailto:stefan.staudenmeyer@instana.com "Stefan Staudenmeyer")

Copyright 2016, INSTANA Inc (All rights reserved)
