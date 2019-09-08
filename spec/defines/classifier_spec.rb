require 'spec_helper'

describe 'facter::classifier' do
  let(:title) { 'namevar' }
  let :pre_condition do
        'include facter'
  end

  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end


end
