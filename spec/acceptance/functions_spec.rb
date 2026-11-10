# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'extlib functions' do
  context 'with extlib::mkdir_p' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          $dirs = extlib::mkdir_p('/tmp/extlib/mkdir_p/a/b', ['/tmp/extlib/mkdir_p/c'])
          file { '/tmp/extlib/mkdir_p.txt':
            ensure  => file,
            content => $dirs.join("\\n"),
          }
        PUPPET
      end
    end

    %w[/tmp/extlib/mkdir_p/a/b /tmp/extlib/mkdir_p/c].each do |dir|
      describe file(dir) do
        it { is_expected.to be_directory }
      end
    end

    describe file('/tmp/extlib/mkdir_p.txt') do
      let(:dirs) { %w[/tmp /tmp/extlib /tmp/extlib/mkdir_p /tmp/extlib/mkdir_p/a /tmp/extlib/mkdir_p/a/b /tmp/extlib/mkdir_p/c] }

      its(:content) { is_expected.to eq(dirs.join("\n")) }
    end
  end

  # A new random password on every run, so the second run is only idempotent if the cache is used
  context 'with extlib::cache_data' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          file { '/tmp/extlib_cache_data.txt':
            ensure  => file,
            content => extlib::cache_data('extlib_acceptance', 'password', extlib::random_password(16)),
          }
        PUPPET
      end
    end

    describe file('/opt/puppetlabs/puppet/cache/extlib_acceptance/password') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 600 }
      it { is_expected.to be_owned_by 'root' }

      it 'holds the value written to the managed file' do
        expect(subject.content).to eq("--- #{file('/tmp/extlib_cache_data.txt').content}\n")
      end
    end
  end

  context 'with extlib::default_content' do
    before(:all) do
      create_remote_file(default, '/tmp/extlib_template.epp', "<%= 'from' %> epp\n")
      create_remote_file(default, '/tmp/extlib_template.erb', "<%= 'from' %> erb\n")
    end

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          file { '/tmp/extlib_default_content_string':
            ensure  => file,
            content => extlib::default_content("from content\\n", '/tmp/extlib_template.epp'),
          }
          file { '/tmp/extlib_default_content_epp':
            ensure  => file,
            content => extlib::default_content(undef, '/tmp/extlib_template.epp'),
          }
          file { '/tmp/extlib_default_content_erb':
            ensure  => file,
            content => extlib::default_content('', '/tmp/extlib_template.erb'),
          }
        PUPPET
      end
    end

    {
      'string' => "from content\n",
      'epp' => "from epp\n",
      'erb' => "from erb\n",
    }.each do |source, content|
      describe file("/tmp/extlib_default_content_#{source}") do
        its(:content) { is_expected.to eq(content) }
      end
    end
  end

  context 'with extlib::has_module' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          $modules = ['puppet-extlib', 'puppetlabs/stdlib', 'voxpupuli/extlib', 'puppetlabs/nonexistent']
          file { '/tmp/extlib_has_module.txt':
            ensure  => file,
            content => $modules.map |$m| { "${m}=${extlib::has_module($m)}\\n" }.join,
          }
        PUPPET
      end
    end

    describe file('/tmp/extlib_has_module.txt') do
      its(:content) do
        is_expected.to eq(<<~TXT)
          puppet-extlib=true
          puppetlabs/stdlib=true
          voxpupuli/extlib=false
          puppetlabs/nonexistent=false
        TXT
      end
    end
  end

  context 'with extlib::to_ini' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          file { '/tmp/extlib.ini':
            ensure  => file,
            content => extlib::to_ini(
              { 'main' => { 'string' => 'value', 'bool' => true, 'number' => 1 } },
              { 'quote_booleans' => false },
            ),
          }
        PUPPET
      end
    end

    describe file('/tmp/extlib.ini') do
      its(:content) do
        is_expected.to eq(<<~INI)
          # THIS FILE IS CONTROLLED BY PUPPET

          [main]
          string="value"
          bool=true
          number="1"
        INI
      end
    end
  end

  context 'with extlib::sort_by_version' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
          file { '/tmp/extlib_sort_by_version.txt':
            ensure  => file,
            content => extlib::sort_by_version(['10.0.0b12', '10.0.0b3', '10.0.0a2', '9.0.10', '9.0.3']).join("\\n"),
          }
        PUPPET
      end
    end

    describe file('/tmp/extlib_sort_by_version.txt') do
      its(:content) { is_expected.to eq(%w[9.0.3 9.0.10 10.0.0a2 10.0.0b3 10.0.0b12].join("\n")) }
    end
  end
end
