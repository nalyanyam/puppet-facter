class facter (
  $classifier                     = undef,
  String $facts_d_dir             = 'USE_DEFAULTS',
  Hash $facts_hash                = {},
  String $facts_file              = 'facts.yaml',
  Boolean $purge_facts_d          = false,
) {
  
  case $::kernel {
    'Linux': {
      $default_facts_d_dir = '/etc/puppetlabs/facter/facts.d'
    }
    'windows': {
      $default_facts_d_dir = 'C:\ProgramData\PuppetLabs\facter\facts.d'
    }
    default: {
      #fail("facter module has only been tested on Linux and windows kernels: Detected kernel is <${::kernel}>.")
      # Users could provide PATH in hiera to support other kernels
    }
  }

  if $facts_d_dir == 'USE_DEFAULTS' {
    $facts_d_dir_real = $default_facts_d_dir
  } else {
    $facts_d_dir_real = $facts_d_dir
  }

  validate_absolute_path($facts_d_dir_real)
  validate_absolute_path("${facts_d_dir_real}/${facts_file}")


  file { 'facts_d_directory':
    path    => $facts_d_dir_real,
    ensure  => 'directory',
    purge   => $purge_facts_d,
  }
  file { "facts_file_${name}":
    ensure => file,
    path   => "${facts_d_dir_real}/${facts_file}",
    #owner  => $facter::facts_file_owner,
    #group  => $facter::facts_file_group,
    #mode   => $facter::facts_file_mode,
  }


  # https://stackoverflow.com/questions/48714819/accessing-multiple-nested-hiera-values-from-puppet-code-or-puppet-lookup-cmd
  #lookup(facter::classifier, Hash).each |String $key, Hash $value| {
  ## first $key is 'some uniq name' string
  ## first $value is 'some uniq name' hash
    #$value['baz'] # first value is 12345

   $facts_defaults = {
      'file'      => $facts_file,
      'facts_dir' => $facts_d_dir,
    }



   $hostlist_array = lookup(facter::classifier, Hash).map |String $key, Hash $value| {
      $hostlist =  $value['hostlist']
   }
   $filtered_array = lookup(facter::classifier, Hash).map |String $uniq_key, Hash $value| {
     case $hostname {
       *$value['hostlist']: {
         $value['facts_hash'].map |String $key, Hash $newfacts_hash| {
           #flatten($newfacts_hash['value'])
           #$newfacts_hash['value']
           #$key
           facter::classifier { "$uniq_key -  $newfacts_hash":
             key => $key,
             fact_value => $newfacts_hash['value'],
             facts_file => $facts_file,
             facts_d_dir => $facts_d_dir_real,
             facts_hash  => $facts_hash,
             hostlist    => $value['hostlist'],
           }

         }
       }
       default: {
         #false
       }
     }
     # End for case statement
   }
   # End for $filtered_array

   # Only for debugging
   #notify {"Filtered_array: $filtered_array": }


}
