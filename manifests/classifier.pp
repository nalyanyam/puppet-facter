# Class facter::classifier
#
# Manage yaml based external facts.
#
define facter::classifier (
  $hostlist    = "$facter::hostlist",
  #$hostlist_array     = "$facter::hostlist_array",
  $fact_value = "$facter::fact_value",
  $key  = "$facter::key",
  $facts_hash = "$facter::facts_hash",
  $facts_file  = "$facter::facts_file",
  $facts_d_dir = "$facter::facts_d_dir_real",

) {

  include ::facter 


  

  #$match = "^${key}:"
  ##########################


  #case $hostname {

  case $trusted['hostname'] {
    # using splat function
    *$hostlist: {
                   $host_fact = true
    }
    default:  {
                $host_fact = false
              }
  }


  if $host_fact == true {
  file_line { "fact_line_${name}-${key}-$fact_value":
    path  => "${facts_d_dir}/${facts_file}",
    line  => "${key}: $fact_value",
    match => "^${key}:",
    #match => "$match",
  }

  }
  # Closes the if $host_fact

  #notify {"Facter values from classifier: $fact_value": }
  #notify {"hostlist from classifier-$fact_value: $hostlist": }

  #}
}
