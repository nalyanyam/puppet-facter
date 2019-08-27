#####
===

Puppet module to manage Facter.
Module to manage custom facts from the server.

Inspiration from other facter modules from github. To use do the following.

inlcude classes like
include ::facter

===


The hashes can be defined in a common hiera level

Without hash definitions, module would only create facts.yaml fact file

facts_hash_hiera_merge
----------------------
Boolean value to control merging of all found instances of facter::classifier in Hiera. When set to true, all facts hashes defined at different hiera levels will be included in the catalog.

- *Default*: false

facts_file
---------
The name of the facts file. Default is facts.yaml

purge_facts_d
-------------
Whether to purge the facts_file contents not managed by Puppet. Default is false

facts_d_dir
----------
The directory where the facts files are located. By default this directory already exists under the following path: /etc/puppetlabs/facter/facts.d for Linux and C:\ProgramData\PuppetLabs\facter\facts.d for Windows. 

facter::classifier
------------------
Defines a hash of hostlists and the assigned groups, profiles, roles etc.

## Usage
Example hiera definitions.

<pre>
---
facter::classifier:
  'newgroup':
    hostlist:
      - test1
      - test2
      - test3
    facts_hash:
        role:
          value: WinTestserver
</pre>

##
This facter module borrowed heavily the concepts used in ghoneycutt/puppet-module-facter.

##
To be improved.
