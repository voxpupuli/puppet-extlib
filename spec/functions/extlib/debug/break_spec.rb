require 'spec_helper'
require 'puppet-debugger'

describe 'extlib::debug::break' do
 
  it do 
    allow(PuppetDebugger::Cli).to receive(:start_without_stdin).with({:scope=>anything, :source_file=>nil, :source_line=>nil}).and_return(true)
    # 1 is the number of debugger instances currently running
    is_expected.to run.with_params().and_return(1)
  end
end
