require 'spec_helper'

describe 'facter' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }
      it { is_expected.to compile }
    end
  end


  #context 'with default options' do
  context 'with kernel Linux options' do
    let(:facts) { { :kernel => 'Linux' } }

    let(:params) do
        { :name => 'name', 
          :purge_facts_d => false,

        }
    end

    it { should contain_class('facter') }


    it { should contain_file('facts_file_name').with({
        'ensure'  => 'file',
        'path'    => '/etc/puppetlabs/facter/facts.d/facts.yaml',
      })
    }

    it {
      should contain_file('facts_d_directory').with({
        'ensure'  => 'directory',
        'path'    => '/etc/puppetlabs/facter/facts.d',
        'purge'   => false,
      })
    }

  end

  context 'with kernel windows options' do
    let(:facts) { { :kernel => 'windows' } }

    let(:params) do
        { :name => 'name', 
          :purge_facts_d => false,

        }
    end

    it { should contain_class('facter') }


    it { should contain_file('facts_file_name').with({
        'ensure'  => 'file',
        'path'    => 'C:\ProgramData\PuppetLabs\facter\facts.d/facts.yaml',
      })
    }

    it {
      should contain_file('facts_d_directory').with({
        'ensure'  => 'directory',
        'path'    => 'C:\ProgramData\PuppetLabs\facter\facts.d',
        'purge'   => false,
      })
    }

  end
end