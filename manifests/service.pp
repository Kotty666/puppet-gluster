# @summary manage the glusterd service
# @api private
#
# @param ensure
#   State of the service to ensure
# @param enable
#   Whether or not to enable the service
# @param service_name
#   Name of the service to manage
#
# @example
#   class { gluster::service:
#     ensure => running,
#   }
#
# @author Scott Merrill <smerrill@covermymeds.com>
# @note Copyright 2014 CoverMyMeds, unless otherwise noted
#
class gluster::service (
  $ensure       = lookup('gluster::service_ensure', Boolean, deep),
  $enable       = lookup('gluster::service_enable', Boolean, deep),
  $service_name = lookup('gluster::service_name', String, deep),
) {
  service { $service_name :
    ensure     => $ensure,
    enable     => $enable,
    hasrestart => true,
    hasstatus  => true,
  }
}
