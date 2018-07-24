require 'spec_helper'

describe 'test.example.com' do
  on_supported_os.each do |os, facts|
    context "data_showcase with database credentials set on #{os}" do
      let(:facts) { facts }
      it { is_expected.to create_class('data_showcase') }
    end
  end
end
