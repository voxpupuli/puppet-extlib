# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::echo' do
  describe 'signature validation' do
    it 'exists' do
      expect(subject).not_to be_nil
    end

    it 'requires at least one argument' do
      expect(subject).to run.with_params.and_raise_error(ArgumentError)
    end
  end

  context 'with a string' do
    it 'outputs a correct debug string' do
      allow(scope).to receive(:debug).with '(String) "test"'
      expect(subject).to run.with_params('test')
    end
  end

  context 'with a string with a comment' do
    it 'outputs a correct debug string' do
      allow(scope).to receive(:debug).with 'My String (String) "test"'
      expect(subject).to run.with_params('test', 'My String')
    end
  end

  context 'with an array' do
    it 'outputs a correct debug string' do
      allow(scope).to receive(:debug).with 'My Array (Array) ["1", "2", "3"]'
      expect(subject).to run.with_params(%w[1 2 3], 'My Array')
    end
  end

  context 'with a hash' do
    it 'outputs a correct debug string' do
      allow(scope).to receive(:debug).with 'My Hash (Hash) {"a"=>"1"}'
      expect(subject).to run.with_params({ 'a' => '1' }, 'My Hash')
    end
  end

  context 'with a boolean value' do
    it 'outputs a correct debug string' do
      allow(scope).to receive(:debug).with 'My Boolean (FalseClass) false'
      expect(subject).to run.with_params(false, 'My Boolean')
    end
  end

  context 'with an undefind value' do
    it 'outputs a correct debug string' do
      allow(scope).to receive(:debug).with 'Undefined Value (NilClass) nil'
      expect(subject).to run.with_params(nil, 'Undefined Value')
    end
  end
end
