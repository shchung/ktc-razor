require 'chefspec'

describe 'ktc-base::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'ktc-base::default' }
  it 'does something' do
    pending 'Your recipe examples go here.'
  end
end