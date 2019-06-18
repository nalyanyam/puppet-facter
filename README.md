#####
some quick hack to manage custom facts from the server

Inspiration from other facter modules from github

The hashes can be defined in a common hiera level

inlcude classes like
include ::facter


Without hash definitions, module would only create facts.yaml fact file

Example hiera definitions.

facter::classifier:
  'newgroup':
    hostlist:
      - test1
      - test2
      - test3
    facts_hash:
        role:
          value: WinTestserver

#
To be improved.
