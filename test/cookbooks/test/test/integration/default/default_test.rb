# InSpec test for recipe test::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

if os.windows?
	describe service('Instana Agent') do
		it { should be_installed }
		it { should be_running }
	end
end

unless os.windows?
	describe service('instana-agent') do
		it { should be_installed }
		it { should be_running }
	end
end
