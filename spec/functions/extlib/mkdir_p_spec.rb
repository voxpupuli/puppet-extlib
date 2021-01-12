require 'spec_helper'

describe 'extlib::mkdir_p' do
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
        is_expected.to run.with_params(dirs).and_return(["/c", "/c/temp", "/c/temp/gems",
           "/c/windows", "/c/windows/puppetlabs", "/c/windows/puppetlabs/puppet",
           "/c/windows/puppetlabs/puppet/embedded",
           "/c/windows/puppetlabs/puppet/embedded/gems"])
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
      let(:expected_dirs) do
        ['/opt', '/opt/puppetlabs', '/opt/puppetlabs/puppet',
         '/opt/puppetlabs/puppet/embedded', '/opt/puppetlabs/puppet/embedded/bin',
         '/opt/puppetlabs/puppet/embedded/bin/gems', '/tmp', '/tmp/gems']
      end

      it { is_expected.to run.with_params(dirs).and_return(expected_dirs) }
    end

    describe 'multiple_dirs with comma' do
      
      let(:expected_dirs) do
        ['/opt', '/opt/puppetlabs', '/opt/puppetlabs/puppet',
         '/opt/puppetlabs/puppet/embedded', '/opt/puppetlabs/puppet/embedded/bin',
         '/opt/puppetlabs/puppet/embedded/bin/gems', '/tmp', '/tmp/gems']
      end

      it { is_expected.to run.with_params('/opt/puppetlabs/puppet/embedded/bin/gems', '/tmp/gems').and_return(expected_dirs) }
    end
  end
end
