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

Since `puppet/extlib` version 3, all functions are provided under the `extlib` namespace.
Non namespaced versions are available in this release, but deprecated and will be removed in the next major release.

All functions are documented in [REFERENCE.md](REFERENCE.md)

## Limitations

Some functions require puppetlabs-stdlib (>= 4.6.0) and all functions are only compatible with Puppet 4.7 and later.

## Development

We highly welcome new contributions to this module, especially those that
include documentation, and rspec tests ;) but will happily guide you through
the process, so, yes, please submit that pull request!

Reference documentation is generated using puppet-strings.
To regenerate it, please run the rake task as follows.
```console
 % bundle exec rake strings:generate\['lib/puppet/functions/extlib/*.rb,,,,false,true']
```
