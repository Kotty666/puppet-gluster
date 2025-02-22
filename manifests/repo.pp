# @summary enables an upstream GlusterFS repository
# @api private
#
# @note that this module is a wrapper for sub-classes that implement
#   the specific repository type, ie:  gluster::repo::yum
#
# @param version
#    the version of the upstream repo to enable
#
# @example
#   class { gluster::repo
#     version => '3.5.2',
#   }
#
# @author Scott Merrill <smerrill@covermymeds.com>
# @note Copyright 2014 CoverMyMeds, unless otherwise noted
#
class gluster::repo (
  $release = lookup('gluster::release',String, deep),
  $version = lookup('gluster::version',String, deep),
) {
  case $facts['os']['family'] {
    'RedHat': {
      class { 'gluster::repo::yum':
        release => $release,
      }
    }
    'Debian': {
      class { 'gluster::repo::apt':
        version  => $version,
      }
    }
    default: { fail("${facts['os']['family']} not yet supported!") }
  }
}
