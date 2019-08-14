# encoding: utf-8

# instana-agent - Attributes file - defining attributes for the instana-agent

# Author:: Stefan Staudenmeyer <stefan.staudenmeyer@instana.com>
# Copyright:: 2017, Instana, Inc.
# License:: Apache-2.0

# We ship our Instana Agent in two flavors: "dynamic" and "static".
# The static flavored agent comes with a JDK (Zulu OpenJDK in a recent
# version) and a set of all recent sensors that we ship on a daily basis.
# It is the perfect fit when you have strict firewall settings and don't
# want the agents to connect to the internet, ever.
# The dynamic flavored agent comes with a JDK as well, and downloads the
# required sensors on startup phase.
# Possible values: "static" | "dynamic".
# See:: https://docs.instana.io/quick_start/agent_setup/linux/#whats-in-it
default['instana']['agent']['flavor'] = 'static'

# When you register with us you receive a string that makes the credentials you
# need in order to download the agent and its sensors. It can be seen as a
# tenantcy identifier across the platform.
# See:: https://docs.instana.io/quick_start/agent_setup/linux/#manual-installation-process
default['instana']['agent']['key'] = ''

# This is the machine the Instana agent will connect to directly. This will
# either be one of our SaaS endpoints, or your Instana on premises installation
# hostname or address.
# See:: https://docs.instana.io/quick_start/agent_setup/linux/#agent-communication
default['instana']['agent']['endpoint']['host'] = 'saas-us-west-2.instana.io'

# See node['instana']['agent']['endpoint']['host']. On our SaaS platform, the
# monitoring endpoint port is 443. For most on premises installations, this
# number is 1444.
# See:: https://docs.instana.io/quick_start/agent_setup/linux/#agent-communication
default['instana']['agent']['endpoint']['port'] = 443

# This mode specifies the mode under which the Instana agent should run.
# Possible values are "apm", "infrastructure" and "off".
# See:: https://docs.instana.io/quick_start/agent_configuration/#agent-mode
default['instana']['agent']['mode'] = 'apm'

# The agent zone is a visual helper under which hosts are being categorized
# on the physical map. This, along with the list of host tags, can help filter
# and search.
# Possible values: a string containing UTF-8 characters.
# See:: https://docs.instana.io/quick_start/agent_configuration/#custom-zones
default['instana']['agent']['zone'] = ''

# The agent tags are a list of strings that will categorize the host machine
# and are. This, along with the list of host tags, can help filter and search.
# See:: https://docs.instana.io/quick_start/agent_configuration/#tags
default['instana']['agent']['tags'] = []

# The Instana agent updates its set of sensors automatically in the background
# unless configured differently.
# Possible values: true | false.
# See:: https://docs.instana.io/quick_start/agent_configuration/#agent-versioning-and-update-management
default['instana']['agent']['update']['enabled'] = false

# See node['instana']['agent']['update']['enabled'].
# Possible values: "DAY" | "MONDAY" | "TUESDAY"...
# See:: https://docs.instana.io/quick_start/agent_configuration/#agent-versioning-and-update-management
default['instana']['agent']['update']['interval'] = 'DAY'

# See node['instana']['agent']['update']['enabled'].
# Possible values: a string containing the time of the day where the update
#   is scheduled, in 24h format.
# See:: https://docs.instana.io/quick_start/agent_configuration/#agent-versioning-and-update-management
default['instana']['agent']['update']['time'] = '04:30' # 24h-format

# We support running the Instana agent with a specific set of sensors.
# Possible values: a string with a git commit hash.
default['instana']['agent']['update']['pin'] = '' # git sha-1 hash

# We support running and updating the Instana agent through a proxy setup.
# See:: https://docs.instana.io/quick_start/agent_configuration/#background
default['instana']['agent']['proxy']['enabled'] = false
default['instana']['agent']['proxy']['type'] = 'http'
default['instana']['agent']['proxy']['host'] = ''
default['instana']['agent']['proxy']['port'] = ''
default['instana']['agent']['proxy']['username'] = ''
default['instana']['agent']['proxy']['password'] = ''

# Please set this to true when the machine can't resolve DNS itself and needs
# this to be taken care of by the proxy.
# See:: node['instana']['agent']['proxy']['enabled']
default['instana']['agent']['proxy']['dns'] = true

# If you mirror our agent sensor and update repository, you can specify its
# credentials and addresses here.
# See:: https://docs.instana.io/quick_start/operators/#further-package-topics
default['instana']['agent']['mirror']['enabled'] = false
default['instana']['agent']['mirror']['auth']['enabled'] = false
default['instana']['agent']['mirror']['auth']['username'] = ''
default['instana']['agent']['mirror']['auth']['password'] = ''
default['instana']['agent']['mirror']['urls']['release'] = ''
default['instana']['agent']['mirror']['urls']['shared'] = ''

# These settings enable you to set hard resource limits for the Instana agent
# and its runtime underneath via Systemd CGroup settings.
# Possible values: true | false
# See:: https://docs.instana.io/quick_start/agent_configuration/#limiting-agents-cpu-and-memory-in-different-environments
# See:: https://www.freedesktop.org/software/systemd/man/systemd.resource-control.html
default['instana']['agent']['limit']['cpu']['enabled'] = true
default['instana']['agent']['limit']['cpu']['quota'] = 0.5 # ( == 50%)
default['instana']['agent']['limit']['memory']['enabled'] = true
default['instana']['agent']['limit']['memory']['maxsize'] = 512 # (MB)

# Default agent config directory, added here for transition at a later date do not change this value
default['instana']['agent']['config_dir'] = '/opt/instana/agent/etc/instana'
