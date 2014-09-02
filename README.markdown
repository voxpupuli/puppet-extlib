####Table of Contents

1. [Overview](#overview)
3. [Setup - The basics of getting started with resources_deep_merge](#setup)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module provides the function `resources_deep_merge`. It's based on
[stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) `deep_merge()`
function. Its intended use to provide hashes, such as those passed to
`create_resources()` with default values.

##Setup

```console
 % puppet module install brainsware-resources_deep_merge
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

This module uses blacksmith for releasing and rspec for tests.
All contributions are highly welcome, especially if they include documentation
and tests.
