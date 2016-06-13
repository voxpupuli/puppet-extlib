require 'spec_helper'

describe 'default_content', type: :puppet_function do
  describe 'signature validation' do
    it 'exists' do
      is_expected.not_to be_nil
    end
  end

  context 'should return the correct string for' do
    it 'a string' do
      is_expected.to run.with_params('a string', :undef).and_return 'a string'
    end
    it 'an empty string and a template' do
      tw = 'a template string'
      Puppet::Parser::TemplateWrapper.stubs(:new).returns(tw)
      tw.stubs(:file=).with('/tmp/foo.erb')
      tw.stubs(:result).returns('a template string')
      is_expected.to run.with_params(:undef, '/tmp/foo.erb').and_return 'a template string'
    end
    it 'an empty string and an empty template' do
      is_expected.to run.with_params(:undef, :undef).and_return :undef
    end
  end
end
