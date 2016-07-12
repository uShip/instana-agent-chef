# instana-agent-onprem Cookbook

This cookbook installs the Instana agent for on premise customers.

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

* `node.default['instana']['endpoint']['url']` = 'https://192.168.0.1/'
* `node.default['instana']['endpoint']['email']` = ''
* `node.default['instana']['endpoint']['password']` = 'chegg'
* `node.default['instana']['agent']['architecture']` = 64
* `node.default['instana']['agent']['os']` = 'linux'
* `node.default['instana']['system_service']['enable']` = true
* `node.default['instana']['system_service']['start']` = true
* **(Optional)** `node.default['javaloc']` = 'Path of your JDK install'

## License and Authors

* [Stefan Staudenmeyer](mailto:stefan.staudenmeyer@instana.com "Stefan Staudenmeyer")

Copyright 2016, INSTANA Inc (All rights reserved)
