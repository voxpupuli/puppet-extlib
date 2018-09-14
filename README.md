# Extlib module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-extlib.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-extlib)
[![Code Coverage](https://coveralls.io/repos/github/voxpupuli/puppet-extlib/badge.svg?branch=master)](https://coveralls.io/github/voxpupuli/puppet-extlib)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)

#### Table of Contents

1. [Overview](#overview)
3. [Setup - The basics of getting started with extlib](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module provides functions that are out of scope for [stdlib](https://github.com/puppetlabs/puppetlabs-stdlib).
Some of them are even intrinsically tied to stdlib.

## Setup

```console
 % puppet module install puppet-extlib
```

## Usage

### resources\_deep\_merge

See [REFERENCE.md](REFERENCE.md#resources_deep_merge)

### echo

This function outputs the variable content and its type to the
debug log. It's similiar to the "notice" function but provides
a better output format useful to trace variable types and values
in the manifests.

```puppet
# examples:
$v1 = 'test'
$v2 = ["1", "2", "3"]
$v3 = {"a"=>"1", "b"=>"2"}
$v4 = true
# $v5 is not defined
$v6 = { "b" => ["1","2","3"] }
$v7 = 12345

echo($v1, 'My string')
echo($v2, 'My array')
echo($v3, 'My hash')
echo($v4, 'My boolean')
echo($v5, 'My undef')
echo($v6, 'My structure')
echo($v7) # no comment here

# debug log output:
# My string (String) "test"
# My array (Array) ["1", "2", "3"]
# My hash (Hash) {"a"=>"1", "b"=>"2"}
# My boolean (TrueClass) true
# My undef (String) ""
# My structure (Hash) {"b"=>["1", "2", "3"]}
# (String) "12345"
```

### cache_data

See [REFERENCE.md](REFERENCE.md#cache_data)

### random\_password

See [REFERENCE.md](REFERENCE.md#random_password)

### default_content

Takes an optional content and an optional template name and returns the contents
of a file.

```puppet
$config_file_content = default_content($file_content, $template_location)
file { '/tmp/x':
  ensure  => 'file',
  content => $config_file_content,
}
```

### ip\_to\_cron

See [REFERENCE.md](REFERENCE.md#ip_to_cron)

### extlib::has\_module

See [REFERENCE.md](REFERENCE.md#extlibhas_module)

## Limitations

This module requires puppetlabs-stdlib >=3.2.1, which is when `deep_merge()`
was introduced.

## Development

We highly welcome new contributions to this module, especially those that
include documentation, and rspec tests ;) but will happily guide you through
the process, so, yes, please submit that pull request!

This module uses [blacksmith](https://github.com/maestrodev/puppet-blacksmith)
for releasing and rspec for tests.

To release a new version please make sure tests pass! Then,

```shell
% rake travis_release
```

This will tag the current state under the version number described in
metadata.json, and then bump the version there so we're ready for the next
iteration. Finally it will `git push --tags` so travis can pick it up and
release it to the forge!
