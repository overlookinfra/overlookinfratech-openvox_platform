# @summary Manages the repository for installing Foreman & friends
#
# This will allow you to install openvox-agent, openvox-server, openvoxdb, etc.
# You *can* specify parameters for testing purposes, but the defaults should be
# accurate for production use.
#
# @note
#   This currently also installs a foreman-support repository where we periodically
#   publish additional packages to support additional features.
#
# @example
#   include openvox_platform::foreman::support
class openvox_platform::foreman::support () {
  case $facts['os']['family'] {
    'Debian': {
      require apt
    }
    'RedHat': {
      yumrepo { 'foreman-support':
        ensure   => 'present',
        baseurl  => 'https://artifacts.voxpupuli.org/foreman-support/',
        descr    => 'Foreman Support Overlook Repository - noarch',
        enabled  => '1',
        gpgcheck => '0',
        priority => '1',
      }
    }
    default: {
      fail("Operating system unsupported: ${facts['os']['name']}")
    }
  }

  # any packages declared in the foreman module should be enforced after this
  Class['openvox_platform::foreman::support'] -> Package <| tag == 'foreman' |>
}
