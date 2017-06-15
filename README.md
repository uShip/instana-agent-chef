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

## Monitoring endpoint

    If you're an onprem customer, please specify your hostname and port in the corresponding
    attributes. If you're using our SaaS offering, and don't know which endpoint the agent 
    should send to, feel free to ask our sales team.

## Attributes

* **(Required)** `node['instana']['agent']['flavor']` = (string) Either "minimal" or "full"

* **(Required)** `node['instana']['agent']['agent_key']` - Your agent key credential (default '')
* **(Required)** `node['instana']['agent']['endpoint']['host']` - Your assigned monitoring endpoint or the hostname of 
    your on premises Instana backend instance (default 'saas-us-west-2.instana.io')
* **(Required)** `node['instana']['agent']['endpoint']['port']` - The port of the monitoring endpoint (default 443)
* **(Optional)** `node['instana']['agent']['flavor']` - The agent flavor, either full or minimal (default 'full')
* **(Optional)** `node['instana']['agent']['jdk']` - In case you're picking the minimal agent - The JDK installation 
    path (default '')
* **(Optional)** `node['instana']['agent']['user']` - Which user the agent should run as (default 'root')
* **(Optional)** `node['instana']['agent']['group']` - Which group the agent should run as (default 'root')
* **(Optional)** `node['instana']['agent']['mode']` - Which mode the agent should run under, either 'apm', 
    'infrastructure' or 'off' (default 'apm')
* **(Optional)** `node['instana']['agent']['update']['enabled']` - Whether the agent should update itself.
* **(Optional)** `node['instana']['agent']['update']['interval']` - Preferred interval of updates, either 'DAY' or a 
    week of the week in caps (default 'DAY')
* **(Optional)** `node['instana']['agent']['update']['time']` - Time of interval for updates (default '04:30') 
* **(Optional)** `node['instana']['agent']['update']['pin']` - Pin the sensor version (git sha hash, default '') 
* **(Optional)** `node['instana']['agent']['proxy']['enabled']` - Can the machine only access the internet through a 
    proxy? (default false)
* **(Optional)** `node['instana']['agent']['proxy']['type']` - The proxy's type (default 'http')
* **(Optional)** `node['instana']['agent']['proxy']['host']` - The proxy's hostname (default '')
* **(Optional)** `node['instana']['agent']['proxy']['port']` - The proxy's port (default 0)
* **(Optional)** `node['instana']['agent']['proxy']['dns']` - Should the machine use the proxy for DNS resolution? 
    (default false)
* **(Optional)** `node['instana']['agent']['proxy']['username']` - If the proxy needs credentials - username 
    (default '')
* **(Optional)** `node['instana']['agent']['proxy']['password']` - Proxy user's password (default '')
* **(Optional)** `node['instana']['agent']['mirror']['enabled']` - Did you set up a sensor mirror for agent updates? 
    (default false)
* **(Optional)** `node['instana']['agent']['mirror']['urls']['release']` - Repo address of the release mirror 
    (default '')
* **(Optional)** `node['instana']['agent']['mirror']['urls']['shared']` - Repo address of the shared mirror 
    (default '')
* **(Optional)** `node['instana']['agent']['mirror']['auth']['enabled']` - Does the mirror require authentication? 
    (default false)
* **(Optional)** `node['instana']['agent']['mirror']['auth']['username']` - Mirror username
* **(Optional)** `node['instana']['agent']['mirror']['auth']['password']` - Mirror password


## License and Authors

* [Stefan Staudenmeyer](mailto:stefan.staudenmeyer@instana.com "Stefan Staudenmeyer")

Copyright 2016, INSTANA Inc (All rights reserved)
