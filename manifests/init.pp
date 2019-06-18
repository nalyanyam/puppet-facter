# == Class: facter
# Manage custom facts from hiera
class facter (
  $classifier                     = undef,
  String $facts_d_dir             = 'USE_DEFAULTS',
  #Hash $facts_hash                = {},
  String $facts_file              = 'facts.yaml',
  Boolean $purge_facts_d          = false,
  Boolean $facts_hash_hiera_merge = true,
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
   $facts_hash = lookup(facter::classifier, Hash).map |String $key, Hash $value| {
      $facts_hash =  $value['facts_hash']
   }

   $facts_hash_array = $facts_hash.each |Integer $index, Hash $value| {
       $facts_hash =  $value['facts_hash']
   }

   # Only for debugging
   #notify{"facts_hash_array : $facts_hash_array": }


   #$facts_hash.each |Integer $index, Hash $facts_hash| {
         

    
    $hostlist_array.each |Integer $index, Array $hostlist_array| {

       #create_resources("facter::classifier",$facts_hash, $facts_defaults)
       facter::classifier { "$hostlist_array -  $facts_hash - $index":
         #fact_value => $fact_value,
         fact      => $fact,
         value     => $value,
         #fact_name => $fact_name,
         facts_file => $facts_file,
         facts_d_dir => $facts_d_dir_real,
         facts_hash  => $facts_hash_array[$index],
         hostlist       => $hostlist_array,
         #hostlist       => $hostlist_array[$index],
         hostlist_array => $hostlist_array,
         #$facts_defaults => $facts_defaults,

       }

      #}
      # Ends $host_fact
    
   # Above was for $facts_hash.each  statement
   } # Ends hostlist_array




}
