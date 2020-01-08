require 'spec_helper'

describe 'facter::classifier' do
  let(:title) { 'namevar' }
  let :pre_condition do
        'include facter'
  end

  #let(:params) do
  #  {}
  #end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
    
      # Contain class facter
      it { is_expected.to contain_class('facter') }

      # Compile with all dependencies
      it { is_expected.to compile.with_all_deps }
    end
  end

  context 'with fact and facts_dir specified and Linux kernel' do
    let(:facts) { { :kernel => 'Linux' } }
    let(:node) { 'test1.localdomain.com' }
    let(:node_params) do
      {
        facts_file:  'facts.yaml',
        facts_d_dir: '/etc/puppetlabs/facter/facts.d',
      }
    end

    it {  
      should contain_file_line('fact_line_newgroup -  {value => fact1value}-role-fact1value').with({
        #'name' => 'name',
        'path' => '/etc/puppetlabs/facter/facts.d/facts.yaml',
        'line' => 'role: fact1value',
        'match' => "^role:",
      })
    }
  
  end

  context 'with fact and facts_dir specified and windows kernel' do
    let(:facts) { { :kernel => 'windows' } }
    let(:node) { 'test1.localdomain.com' }
    let(:facts_file) { 'custom.yaml' }
    let(:params) do
      {
        name:        'name',
        facts_file:  'facts.yaml',
        facts_d_dir: 'C:\ProgramData\PuppetLabs\facter\facts.d',
      }
    end

    it {  
      should contain_file_line('fact_line_newgroup -  {value => fact1value}-role-fact1value').with({
        'path' => 'C:\ProgramData\PuppetLabs\facter\facts.d/facts.yaml',
        'line' => 'role: fact1value',
        'match' => "^role:",
      })
    }
  end
  
end
