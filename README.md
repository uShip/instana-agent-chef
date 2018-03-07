# instana-agent Cookbook

This [Chef](https://chef.io) cookbook installs, configures and runs the monitoring agent for the [Instana monitoring suite](https://www.instana.com).

## Flavors

**`instana-agent-dynamic`**

This blank agent comes bundled with a JDK and is configured to download all neccessary sensors when it starts. Additionally, it is configured to update its set of sensors on a daily basis.

**`instana-agent-static`**

This "gated" agent package is supposed to not connect to the internet at all. It comes with all the recent sensors and a JDK, and is your package of choice when you run a tight firewall setup.

## Monitoring endpoint

If you're an onprem customer, please specify your hostname and port in the corresponding attributes. If you're using our SaaS offering, and don't know which endpoint the agent should send to, feel free to ask our sales team.

## Supported operating systems

See [our official documentation](https://docs.instana.com).

## Attributes

* See [attributes file](https://github.com/instana/cookbook/blob/master/attributes/default.rb).

## License and Authors

Some attributes may be loaded via a chef databag: instana-agent, item: general

Example:
```
{
	"id": "general",
	"flavor": "static",
	"key": "your_agent_key",
	"endpoint_host": "saas-us-west-2.instana.io",
	"endpoint_port": 443,
	"mode": "apm",
	"zone": "production",
	"tags": ["tag", "another"]
}
```

This cookbook is being submitted and maintained under the [Apache v2.0 License](https://github.com/instana/cookbook/blob/master/LICENSE).

* [Zachary Schneider](https://github.com/sigil66 "Zachary Schneider")
* [Stefan Staudenmeyer](https://github.com/doerteDev "Stefan Staudenmeyer")

# Publish to Chef Supermarket

* Update the version number in the module’s metadata.rb file
* Update CHANGELOG.md
* Push changes to the module repository

```
bundle install --binstubs
stove login --username instana --key ~/.ssh/instana.pem
bin/stove
```

Copyright 2017, INSTANA Inc.
