require 'spec_helper'

describe 'echo', type: :puppet_function do
  describe 'signature validation' do
    it 'exists' do
      is_expected.not_to be_nil
    end
    it 'requires at least one argument' do
      is_expected.to run.with_params.and_raise_error(%r{wrong number of arguments}i)
    end
  end

  context 'should output a correct debug string for' do
    it 'a string' do
      allow(scope).to receive(:debug).with '(String) "test"'
      is_expected.to run.with_params('test')
    end
    it 'a string with a comment' do
      allow(scope).to receive(:debug).with 'My String (String) "test"'
      is_expected.to run.with_params('test', 'My String')
    end
    it 'and array' do
      allow(scope).to receive(:debug).with 'My Array (Array) ["1", "2", "3"]'
      is_expected.to run.with_params(%w(1 2 3), 'My Array')
    end
    it 'a hash' do
      allow(scope).to receive(:debug).with 'My Hash (Hash) {"a"=>"1"}'
      is_expected.to run.with_params({ 'a' => '1' }, 'My Hash')
    end
    it 'a boolean value' do
      allow(scope).to receive(:debug).with 'My Boolean (FalseClass) false'
      is_expected.to run.with_params(false, 'My Boolean')
    end
    it 'an undefind value' do
      allow(scope).to receive(:debug).with 'Undefined Value (NilClass) nil'
      is_expected.to run.with_params(nil, 'Undefined Value')
    end
  end
end
