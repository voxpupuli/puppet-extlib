require 'spec_helper'

describe 'extlib::dir_clean' do
  describe 'check functions' do
    let(:dirs) do
      {
        'c:' => '/c',
        'c:\windows\puppetlabs\puppet\embedded\gems' => '/c/windows/puppetlabs/puppet/embedded/gems',
        '/opt/puppetlabs/puppet/embedded/bin/gems' => '/opt/puppetlabs/puppet/embedded/bin/gems',
      }
    end

    it 'valid dirs' do
      dirs.each_pair do |input, output|
        is_expected.to run.with_params(input).and_return(output)
      end
    end
  end
end
