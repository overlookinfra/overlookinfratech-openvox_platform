# @summary This sets up a no-UI OpenVox server
#
# This can be used on its own to set up openvox-server/db without the Foreman
# integration.
#
# @example
#   include openvox_platform::openvox
class openvox_platform::openvox (
  Boolean $foreman                    = $openvox_platform::foreman,
  Boolean $puppetdb                   = $openvox_platform::puppetdb,
  Boolean $storeconfigs               = $openvox_platform::storeconfigs,
  Optional[String[1]] $server_reports = $openvox_platform::server_reports,
  String $server_jvm_min_heap_size    = $openvox_platform::server_jvm_min_heap_size,
  String $server_jvm_max_heap_size    = $openvox_platform::server_jvm_max_heap_size,
  Boolean $server_multithreaded       = $openvox_platform::server_multithreaded,
) {
  assert_private()
  include openvox_platform::openvox::repo

  if $foreman {
    include openvox_platform::postgresql
  }

  if $puppetdb {
    include openvox_platform::openvox::db
  }

  # use Foreman's puppet module for the heavy lifting
  class {'puppet':
    server_package             => 'openvox-server',
    client_package             => 'openvox-agent',
    server                     => true,
    server_reports             => $server_reports,
    server_storeconfigs        => $storeconfigs,
    server_foreman             => $foreman,
    server_common_modules_path => [],
    server_jvm_min_heap_size   => $server_jvm_min_heap_size,
    server_jvm_max_heap_size   => $server_jvm_max_heap_size,
    server_multithreaded       => $server_multithreaded,
  }
}
