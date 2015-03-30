[![Puppet Forge](http://img.shields.io/puppetforge/v/puppet/extlib.svg)](https://forge.puppetlabs.com/puppet/extlib)
[![Build Status](https://img.shields.io/travis/puppet-community/puppetcommunity-extlib/master.svg)](https://travis-ci.org/puppet-community/puppetcommunity-extlib)

####Table of Contents

1. [Overview](#overview)
3. [Setup - The basics of getting started with extlib](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module provides functions that are out of scope out of scope for
[stdlib](https://github.com/puppetlabs/puppetlabs-stdlib). Some of them are
even intristically tied to stdlib.

##Setup

```console
 % puppet module install puppet-extlib
```

##Usage

resources_deep_merge
--------------------

Returns a [deep-merged](#deep_merge) resource hash (hash of hashes).

*Examples:*

```puppet
    $tcresource_defaults = {
      ensure     => 'present',
      attributes => {
        driverClassName => 'org.postgresql.Driver',
      }
    }

    $tcresources = {
      'app1:jdbc/db1' => {
        attributes => {
          url      => 'jdbc:postgresql://localhost:5432/db1',
          userpass => 'user1:pass1',
        },
      },
      'app2:jdbc/db2' => {
        attributes => {
          url      => 'jdbc:postgresql://localhost:5432/db2',
          userpass => 'user2:pass2',
        },
      }
    }
```

When called as:

```puppet
    $result = resources_deep_merge($tcresources, $tcresource_defaults)
```

will return:

```puppet
    {
     'app1:jdbc/db1' => {
       ensure     => 'present',
       attributes => {
         url      => 'jdbc:postgresql://localhost:5432/db1',
         userpass => 'user1:pass1',
         driverClassName => 'org.postgresql.Driver',
       },
     },
     'app2:jdbc/db2' => {
       ensure     => 'present',
       attributes => {
         url      => 'jdbc:postgresql://localhost:5432/db2',
         userpass => 'user2:pass2',
         driverClassName => 'org.postgresql.Driver',
       },
     }
    }
```

- *Type*: rvalue

##Limitations

This module requires puppetlabs-stdlib >=3.2.1, which is when `deep_merge()`
was introduced.

##Development

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
