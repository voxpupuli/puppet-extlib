# frozen_string_literal: true

require 'spec_helper'

describe 'extlib::remove_resource' do
  let(:user_foo) { Puppet::Pops::Types::PResourceType.new('User', 'foo') }
  let(:user_baz) { Puppet::Pops::Types::PResourceType.new('User', 'baz') }

  it { is_expected.not_to be_nil }

  context "when resource doesn't exist" do
    it { is_expected.to run.with_params(user_foo).and_raise_error(Puppet::ParseError, %r{`remove_resource` couldn't remove resource User\['foo'\] from the catalog}) }

    context 'when soft_fail is true' do
      it { is_expected.to run.with_params(user_foo, true) }

      it 'logs a warning' do
        msg = "`remove_resource` couldn't remove resource User['foo'] from the catalog as it wasn't found when `remove_resource` was called."
        allow(Puppet).to receive(:warning)
        subject.execute(user_foo, true)
        expect(Puppet).to have_received(:warning).with(msg)
      end
    end
  end

  context 'when resource is in catalog' do
    let(:pre_condition) do
      <<~MANIFEST
        user { ['foo', 'bar', 'baz']: ensure => present }
      MANIFEST
    end

    it 'removes the resource' do
      expect(subject).to run.with_params(user_foo)
      expect(catalogue.resource('User[foo]')).to be_nil
      expect(catalogue.resource('User[bar]')).not_to be_nil
      expect(catalogue.resource('User[baz]')).not_to be_nil
    end

    context 'when called with Array of resources' do
      it 'removes only those resources' do
        expect(subject).to run.with_params([user_foo, user_baz])
        expect(catalogue.resource('User[foo]')).to be_nil
        expect(catalogue.resource('User[bar]')).not_to be_nil
        expect(catalogue.resource('User[baz]')).to be_nil
      end
    end
  end
end
