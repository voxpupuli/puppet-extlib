# Extlib module for Puppet

[![Build Status](https://travis-ci.org/voxpupuli/puppet-extlib.png?branch=master)](https://travis-ci.org/voxpupuli/puppet-extlib)
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

See [REFERENCE.md](REFERENCE.md#echo)

### cache\_data

See [REFERENCE.md](REFERENCE.md#cache_data)

### random\_password

See [REFERENCE.md](REFERENCE.md#random_password)

### default\_content

See [REFERENCE.md](REFERENCE.md#default_content)

### ip\_to\_cron

See [REFERENCE.md](REFERENCE.md#ip_to_cron)

### extlib::has\_module

See [REFERENCE.md](REFERENCE.md#extlibhas_module)

### dump\_args

See [REFERENCE.md](REFERENCE.md#dump_args)

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
