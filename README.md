# instana-agent Cookbook

This [Chef](https://chef.io) cookbook installs, configures and runs the monitoring agent for the [Instana monitoring suite](https://www.instana.com).

## Flavors

**`instana-agent-dynamic`**

This blank agent comes bundled with a JDK and is configured to download all neccessary sensors when it starts. Additionally, it is configured to update its set of sensors on a daily basis.

**`instana-agent-static`**

This "gated" agent package is supposed to not connect to the internet at all. It comes with all the recent sensors and a JDK, and is your package of choice when you run a tight firewall setup.

## Resources

**`instana_agent`**

Use this resource to install and set up Instana on your infrastructure. It has the following properties:

```ruby
property :flavor, String, name_property: true
property :key, String, required: true
```

Assuming you've set the `default['instana']['agent']['key']` attribute, you can use the resource in your recipe like so:

```ruby
instana_agent 'static' do
  key node['instana']['agent']['key']
end
```

Additionally, if you have different keys per environment, you can store those in Chef Vault or Encrypted Data Bags and switch on the Chef environment or policy group:

```json
# Example "instana-agent" data bag
{
  "id": "general",
  "flavor": "static",
  "endpoint": "saas-us-west-2.instana.io",
  "local_key": "superlongamazinglocalkey",
  "dev_key": "superlongamazingdevkey",
  "production_key": "superlongamazingproductionkey"
}
```

```ruby
# Pull the Instana credentials from the instana-agent encrypted data bag
instana_creds = data_bag_item('instana-agent', 'general')

instana_agent instana_creds['flavor'] do
  key instana_creds["#{node.policy_group}_key"]
end
```

## Dependencies

The Windows support has a dependency on version 8 of the [java_se cookbook](https://github.com/vrivellino/chef-java_se). You'll need to set the attributes per the instructions for that cookbook.

## Monitoring endpoint

If you're an onprem customer, please specify your hostname and port in the corresponding attributes. If you're using our SaaS offering, and don't know which endpoint the agent should send to, feel free to ask our sales team.

## Supported operating systems

See [our official documentation](https://docs.instana.com).

## Attributes

* See [attributes file](https://github.com/instana/cookbook/blob/master/attributes/default.rb).

## Testing

You can test this cookbook by using the "test" cookbook in the `test/cookbooks` directory. That has a dependency on the instana-agent cookbook. It is set up to use [Test Kitchen](https://docs.chef.io/kitchen.html) with [Policyfiles](https://docs.chef.io/policyfile.html). There's an example `kitchen.yml` and `Policyfile.rb` that you'll need to modify to test. If you want to test on Amazon EC2, modify the `kitchen.ec2.yml` file.

## License and Authors

This cookbook is being submitted and maintained under the [Apache v2.0 License](https://github.com/instana/cookbook/blob/master/LICENSE).

* [Zachary Schneider](https://github.com/sigil66 "Zachary Schneider")
* [Stefan Staudenmeyer](https://github.com/doerteDev "Stefan Staudenmeyer")

## Publish to Chef Supermarket

* Update the version number in the module’s metadata.rb file
* Update CHANGELOG.md
* Push changes to the module repository
* Trigger Jenkins Job

Copyright 2017, INSTANA Inc.
