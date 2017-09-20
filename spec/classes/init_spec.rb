require 'spec_helper'
describe 'data_showcase' do
  context 'with default values for all parameters' do
    let(:node) { 'test2.example.com' }
    it { should compile.and_raise_error(/No database user specified./) }
  end
  context 'with database credentials set' do
    let(:node) { 'test.example.com' }
    it { is_expected.to create_class('data_showcase') }
  end
end
