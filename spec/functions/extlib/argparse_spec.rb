# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::argparse' do
  it 'exists' do
    is_expected.not_to be_nil
  end

  it 'requires an argument hash' do
    is_expected.to run.with_params.and_raise_error(ArgumentError)
  end

  context 'with default options' do
    it 'formats string, numeric, and boolean arguments' do
      args = {
        'h' => 'host.example.org',
        'port' => 8080,
        'ssl' => true,
        'debug' => false,
      }

      is_expected.to run.with_params(args).and_return('-h host.example.org --port 8080 --ssl')
    end

    it 'returns an empty string for an empty hash' do
      is_expected.to run.with_params({}).and_return('')
    end

    it 'shell-escapes scalar and array values' do
      args = { 'name' => 'two words', 'items' => ['one item', 'two'] }

      is_expected.to run.with_params(args).and_return('--name two\\ words --items one\\ item,two')
    end

    it 'joins arrays of strings' do
      is_expected.to run.with_params({ 'items' => %w[alpha beta] }).and_return('--items alpha,beta')
    end

    it 'joins arrays of numbers' do
      is_expected.to run.with_params({ 'ports' => [80, 443] }).and_return('--ports 80,443')
    end
  end

  context 'with custom options' do
    it 'prepends the command prefix' do
      is_expected.to run.with_params({ 'name' => 'app' }, '/usr/bin/tool').and_return('/usr/bin/tool --name app')
    end

    it 'uses a custom switch-value separator' do
      is_expected.to run.with_params({ 'name' => 'app' }, '', '=').and_return('--name=app')
    end

    it 'joins array values with the configured delimiter' do
      is_expected.to run.with_params({ 'items' => %w[one two] }, '', ' ', ':').and_return('--items one:two')
    end

    it 'uses an explicitly configured single-character argument prefix' do
      is_expected.to run.with_params({ 'name' => 'app' }, '', ' ', ',', '-').and_return('-name app')
    end

    it 'uses an explicitly configured two-character argument prefix' do
      is_expected.to run.with_params({ 'name' => 'app' }, '', ' ', ',', '--').and_return('--name app')
    end

    it 'combines custom command prefix, separator, array delimiter, and argument prefix' do
      args = { 'items' => %w[alpha beta], 'ports' => [80, 443] }

      is_expected.to run.with_params(args, '/usr/bin/tool', '=', ':', '-').and_return(
        '/usr/bin/tool -items=alpha:beta -ports=80:443',
      )
    end
  end

  it 'rejects keys that are not non-empty strings' do
    is_expected.to run.with_params({ '' => 'value' }).and_raise_error(ArgumentError)
  end
end
