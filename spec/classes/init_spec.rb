require 'spec_helper'
describe 'data_showcase' do
  on_supported_os.each do |os, facts|
    context "with default values for all parameters on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test2.example.com' }
      it { should compile.and_raise_error(/No database user specified./) }
    end
    context "with database credentials set on #{os}" do
      let(:facts) { facts }
      let(:node) { 'test.example.com' }
      it { is_expected.to create_class('data_showcase') }
    end
  end
end
