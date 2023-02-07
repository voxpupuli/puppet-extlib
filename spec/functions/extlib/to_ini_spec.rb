# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::to_ini' do
  let(:example_input) do
    {
      'main' => {
        'logging' => 'INFO',
        'limit'   => 314,
        'awesome' => true,
      },
      'dev' => {
        'logging'      => 'DEBUG',
        'log_location' => '/var/log/dev.log',
      }
    }
  end

  it { is_expected.not_to eq(nil) }

  context 'default settings' do
    let(:output) do
      <<~EOS
        # THIS FILE IS CONTROLLED BY PUPPET

        [main]
        logging="INFO"
        limit="314"
        awesome="true"

        [dev]
        logging="DEBUG"
        log_location="/var/log/dev.log"
      EOS
    end

    it { is_expected.to run.with_params(example_input).and_return(output) }
  end

  context 'custom settings' do
    let(:settings) do
      {
        'header' => '; THIS FILE IS CONTROLLED BY /dev/random',
        'section_prefix' => '[[',
        'section_suffix' => ']]',
        'key_val_separator' => ': ',
        'quote_char' => '',
      }
    end
    let(:output) do
      <<~EOS
        ; THIS FILE IS CONTROLLED BY /dev/random

        [[main]]
        logging: INFO
        limit: 314
        awesome: true

        [[dev]]
        logging: DEBUG
        log_location: /var/log/dev.log
      EOS
    end

    it { is_expected.to run.with_params(example_input, settings).and_return(output) }
  end

  context 'default settings with custom quoting' do
    let(:settings) do
      {
        'quote_booleans' => false,
        'quote_numerics' => false,
      }
    end
    let(:output) do
      <<~EOS
        # THIS FILE IS CONTROLLED BY PUPPET

        [main]
        logging="INFO"
        limit=314
        awesome=true

        [dev]
        logging="DEBUG"
        log_location="/var/log/dev.log"
      EOS
    end

    it { is_expected.to run.with_params(example_input, settings).and_return(output) }
  end
end
