require 'spec_helper'

describe 'facter' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:hiera_config) { 'spec/fixtures/hiera/hiera.yaml' }

      it { is_expected.to compile.with_all_deps }
    end
  end

  # context 'with default options' do
  context 'with kernel Linux options' do
    let(:facts) do
      {
        kernel:  'Linux',
        hostname:  'test1',
      }
    end

    let(:params) do
      {
        name:  'name',
        purge_facts_d:  false,
        facts_d_dir:    '/factsdir',
        facts_file:     'customs.yaml',
      }
    end

    it { is_expected.to contain_class('facter') }

    it {
      is_expected.to contain_file('facts_file_name').with(
        'ensure'  => 'file',
        'path'    => '/factsdir/customs.yaml',
      )
    }

    it {
      is_expected.to contain_file('facts_d_directory').with(
        'ensure'  => 'directory',
        'path'    => '/factsdir',
        'purge'   => false,
      )
    }
  end

  context 'with kernel windows options' do
    let(:facts) do
      {
        kernel:  'windows',
        hostname:  'test1',
      }
    end

    let(:params) do
      {
        name:  'name',
        purge_facts_d: false,
      }
    end

    it { is_expected.to contain_class('facter') }

    it {
      is_expected.to contain_file('facts_file_name').with(
        'ensure'  => 'file',
        'path'    => 'C:\ProgramData\PuppetLabs\facter\facts.d/facts.yaml',
      )
    }

    it {
      is_expected.to contain_file('facts_d_directory').with(
        'ensure'  => 'directory',
        'path'    => 'C:\ProgramData\PuppetLabs\facter\facts.d',
        'purge'   => false,
      )
    }
  end
end
