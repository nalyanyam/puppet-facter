# Class facter::classifier
#
# Manage yaml based external facts.
#
define facter::classifier (
  $hostlist    = "$facter::hostlist",
  $hostlist_array     = "$facter::hostlist_array",
  $case_hostlist_array     = "$facter::case_hostlist_array",
  $facts_hash  = "$facter::facts_hash",
  #$fact_value,
  $value,
  $fact       = $name,
  #$fact_name,
  $facts_file  = "$facter::facts_file",
  $facts_d_dir = "$facter::facts_d_dir_real",

) {

  include ::facter


  

  #$match = "^${key}:"
  ##########################
  $facts_hash.each |$key, $value| {

  #$fact_val = $facts_hash['value']
  $fact_val = $value['value']

  case $hostname {
    # using splat function
    *$hostlist: {
                   $host_fact = true
    }
    default:  {
                $host_fact = false
              }
  }


  if $host_fact == true {
  file_line { "fact_line_${name}-${key}-$fact_val":
    path  => "${facts_d_dir}/${facts_file}",
    line  => "${key}: $fact_val",
    match => "^${key}:",
    #match => "$match",
  }

  }
  # Closes the if $host_fact

  }
  # Closes the facts_hash.each
}
