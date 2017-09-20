require 'spec_helper'

describe 'test.example.com' do
  context 'data_showcase with database credentials set' do
    it { is_expected.to create_class('data_showcase') }
  end
end
