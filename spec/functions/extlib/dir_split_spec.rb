require 'spec_helper'

describe 'extlib::dir_split' do
  describe 'windows' do
    let(:dirs) do
      'c:\windows\puppetlabs\puppet\embedded\gems'
    end
    let(:facts) do
      {
        kernel: 'windows'
      }
    end

    it {
      is_expected.to run.with_params(dirs).and_return(['/c', '/c/windows', '/c/windows/puppetlabs',
                                                       '/c/windows/puppetlabs/puppet', '/c/windows/puppetlabs/puppet/embedded',
                                                       '/c/windows/puppetlabs/puppet/embedded/gems'])
    }

    describe 'multiple_dirs' do
      let(:dirs) do
        ['c:\windows\puppetlabs\puppet\embedded\gems', 'c:\temp\gems']
      end

      it {
        is_expected.to run.with_params(dirs).and_return(['/c', '/c/windows', '/c/windows/puppetlabs',
                                                         '/c/windows/puppetlabs/puppet', '/c/windows/puppetlabs/puppet/embedded',
                                                         '/c/windows/puppetlabs/puppet/embedded/gems', '/c/temp', '/c/temp/gems'])
      }
    end
  end

  describe 'not_windows' do
    let(:dirs) do
      '/opt/puppetlabs/puppet/embedded/bin/gems'
    end
    let(:facts) do
      {
        kernel: 'linux'
      }
    end

    it {
      is_expected.to run.with_params(dirs).and_return(['/opt', '/opt/puppetlabs', '/opt/puppetlabs/puppet',
                                                       '/opt/puppetlabs/puppet/embedded', '/opt/puppetlabs/puppet/embedded/bin', '/opt/puppetlabs/puppet/embedded/bin/gems'])
    }

    describe 'multiple_dirs' do
      let(:dirs) do
        ['/opt/puppetlabs/puppet/embedded/bin/gems', '/tmp/gems']
      end

      it {
        is_expected.to run.with_params(dirs).and_return(['/opt', '/opt/puppetlabs', '/opt/puppetlabs/puppet',
                                                         '/opt/puppetlabs/puppet/embedded', '/opt/puppetlabs/puppet/embedded/bin',
                                                         '/opt/puppetlabs/puppet/embedded/bin/gems', '/tmp', '/tmp/gems'])
      }
    end
  end
end
