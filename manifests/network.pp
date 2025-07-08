# @summary Opens up ports and such for all the components of the OpenVox platform
#
# This is used by the installer and may not be suitable if you happen to reuse
# this module for your own purposes.
#
# @example
#   include openvox_platform::network
class openvox_platform::network {
  require nftables
  require nftables::rules::out::hkp # ensures we can download the apt key
  require nftables::rules::http
  require nftables::rules::https
}
