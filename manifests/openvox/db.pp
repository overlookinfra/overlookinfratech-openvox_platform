# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include openvox_platform::openvox::db
class openvox_platform::openvox::db {
  assert_private()

  require openvox_platform::postgresql
  include postgresql::server::contrib

  class { 'puppetdb':
    puppetdb_package => 'openvoxdb',
    manage_dbserver  => false,
    manage_firewall  => false,
  }
  class { 'puppetdb::master::config':
    puppetdb_server             => $facts['networking']['fqdn'],
    terminus_package            => 'openvoxdb-termini',
    puppetdb_port               => 8081,
    puppetdb_soft_write_failure => false,
    manage_storeconfigs         => false,
    restart_puppet              => false,
  }

  # Next version of the puppet module will manage this for us, replacing ^^
  # class { 'puppet::server::puppetdb':
  #   server           => $facts['networking']['fqdn'],
  #   terminus_package => openvoxdb-termini,
  # }

  postgresql::server::extension { 'pg_trgm':
    database => 'puppetdb',
    require  => Postgresql::Server::Db['puppetdb'],
    before   => Service['puppetdb'],
  }

  contain puppetdb
  #contain puppet::server::puppetdb
}
