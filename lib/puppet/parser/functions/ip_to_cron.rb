#
# ip_to_cron.rb
#
# Copyright 2016 Vox Pupuli
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module Puppet::Parser::Functions
  newfunction(:ip_to_cron, :type => :rvalue, :doc => <<-EOS
Returns an array of valid cron times given an optional runinterval

Prototype:

    ip_to_cron(n)

Where n is a non-negative value that denotes how often this cron should run in seconds

For example:

  Given the following statements:

  notice ip_to_cron(2500)
  notice ip_to_cron(5500)
  notice ip_to_cron(7500)

The results will be as follows, varying on FQDN and network addresses:

  notice: Scope(Class[main]):
  notice: Scope(Class[main]):
  notice: Scope(Class[main]):
EOS
             ) do |args|
    ip          = lookupvar('ipaddress6') || lookupvar('ipaddress')
    runinterval = (args[0] || 30).to_i
    hourly      = runinterval <= 3600
    occurances  = (hourly ? 3600 : 86_400) / runinterval
    scope       = hourly ? 60 : 24
    base        = function_fqdn_rand([scope, ip.to_s])
    hour        = hourly ? '*' : (1..occurances).map { |i| (base - (scope / occurances * i)) % scope }.sort
    minute      = hourly ? (1..occurances).map { |i| (base - (scope / occurances * i)) % scope }.sort : (base % 60)
    [hour, minute]
  end
end
# vim: set ts=2 sw=2 et :
# encoding: utf-8
