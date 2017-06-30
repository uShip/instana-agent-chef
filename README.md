# instana-agent Cookbook

This [Chef](https://chef.io) cookbook installs, configures and runs the monitoring agent
for the [Instana monitoring suite](https://www.instana.com).

## Requirements

At the moment, one of the following JVMs are required for running the agent:

* Oracle Hotspot JDK 8
* Zulu JDK 8
* IBM J9 8

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

## Supported operating systems

See [our official documentation](https://docs.instana.com).

## Attributes

* See [attributes file](https://github.com/instana/cookbook/blob/master/attributes/default.rb).

## License and Authors

This cookbook is being submitted and maintained under the [Apache v2.0 License](https://github.com/instana/cookbook/blob/master/LICENSE).

* [Zachary Schneider](https://github.com/sigil66 "Zachary Schneider")
* [Stefan Staudenmeyer](https://github.com/doerteDev "Stefan Staudenmeyer")

Copyright 2017, INSTANA Inc.
