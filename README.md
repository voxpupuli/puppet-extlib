# Extlib module for Puppet

[![Build Status](https://github.com/voxpupuli/puppet-extlib/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-extlib/actions?query=workflow%3ACI)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)

## Table of Contents

1. [Overview](#overview)
1. [Setup - The basics of getting started with extlib](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Overview

This module provides functions and facts that are out of scope for [stdlib](https://github.com/puppetlabs/puppetlabs-stdlib).
Some of them are even intrinsically tied to stdlib.

## Setup

```console
 % puppet module install puppet-extlib
```

## Usage

Since `puppet/extlib` version 3, all functions are provided under the `extlib` namespace.
Non namespaced versions were removed in version 5.

All functions are documented in [REFERENCE.md](REFERENCE.md)

### Facts

All facts in this module are namespaced and begin `extlib__`.
Facter 4 users can also find all facts under a single `extlib` toplevel
structured fact.

#### `extlib__puppet_config` (or `extlib['puppet_config']` when using facter 4)

A fact to expose puppet.conf settings. These are resolved on the agent, (unlike
`$settings::<setting_name>` which is resolved on the puppet master).

The following sections/settings are included.

```
{
  main => {
    hostpubkey,
    hostprivkey,
    hostcert,
    localcacert,
    ssldir,
    vardir,
    server,
  },
  master => {
    localcacert,
    ssldir,
  }
}
```

### Templates

The module provides general-purpose EPP templates for serializing to common configuration file formats. They rely on `puppetlabs/stdlib` for serialization.

#### Sensitive values

The templates accept data structures that contain `Sensitive` values. The generated file content will include the unwrapped values.

If you want to ensure Puppet does not log the resulting diff, it is recommended to wrap the whole `epp()` call in `Sensitive()`:

```puppet
file { '/etc/myapp/config.yaml':
  ensure  => file,
  content => Sensitive(epp('extlib/yaml.epp', { 'data' => $data })),
}
```

#### `extlib/json.epp`

Render a hash as JSON. The optional `pretty` parameter defaults to `false`. The optional `sort_keys` parameter defaults to `false`; when set to `true`, the data is passed through `extlib::sort_hash_deep` before serialization so that hash keys are rendered in deterministic sorted order.

```puppet
file { '/etc/myapp/config.json':
  ensure  => file,
  content => epp('extlib/json.epp', {
    'data'      => { 'key' => 'value', 'count' => 42 },
    'pretty'    => true,
    'sort_keys' => true,
  }),
}
```

#### `extlib/toml.epp`

Render a hash as TOML. `stdlib::to_toml` sorts keys and sections where order is not semantically meaningful and handles arrays and arrays of tables per the TOML spec. The optional `comments` parameter accepts a single string or an array of strings and is printed as comment lines below the default header.

```puppet
file { '/etc/myapp/config.toml':
  ensure  => file,
  content => epp('extlib/toml.epp', {
    'data'     => { 'section' => { 'key' => 'value' } },
    'comments' => ['Contact USERNAME', 'Do not edit manually'],
  }),
}
```

#### `extlib/yaml.epp`

Render a scalar, array, or hash as plain YAML. The output uses a single leading `---` document marker. The optional `comments` parameter accepts a single string or an array of strings. The optional `sort_keys` parameter defaults to `false`; when set to `true` and the top-level data is a hash, the data is passed through `extlib::sort_hash_deep` before serialization so that hash keys are rendered in deterministic sorted order. Scalars and arrays are not reordered.

```puppet
file { '/etc/myapp/config.yaml':
  ensure  => file,
  content => epp('extlib/yaml.epp', {
    'data'      => { 'key' => 'value' },
    'comments'  => 'Managed by Puppet',
    'sort_keys' => true,
  }),
}
```

## Limitations

Some functions require puppetlabs-stdlib (>= 4.6.0) and all functions are only
compatible with Puppet 4.7 and later.

## Development

We highly welcome new contributions to this module, especially those that
include documentation, and rspec tests ;) but will happily guide you through
the process, so, yes, please submit that pull request!

Reference documentation is generated using puppet-strings.
To regenerate it, please run the rake task as follows.

```console
bundle exec rake reference
```
