# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include openvox_platform::files
class openvox_platform::files {
  file { ['/etc/openvox_platform',]:
    ensure => 'directory',
  }

}
