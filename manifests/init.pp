# @summary Installs GlusterFS and optionally creates a trusted storage pool
#
# @param client
#    whether to install the Gluster client package(s)
# @param pool
#    the name of the trusted storage pool to create
# @param repo
#    whether to install and manage the upstream Gluster repo
# @param server
#    whether to the install the Gluster server packages
# @param use_exported_resources
#    whether or not to export this server's gluster::server and collect other
#    gluster::server resources
# @param version
#    the version to install
# @param volumes
#    optional list of volumes (and their properties) to create
#
# @example
#   class { ::gluster:
#     client                 => false,
#     server                 => true,
#     pool                   => 'production',
#     use_exported_resources => true,
#     version                => '3.5',
#     volumes                => { 'data1' => {
#                                   replica => 2,
#                                   bricks  => [ 'srv1.local:/export/brick1/brick',
#                                                'srv2.local:/export/brick1/brick',
#                                                'srv3.local:/export/brick1/brick',
#                                                'srv4.local:/export/brick1/brick', ],
#                                   options => [ 'server.allow-insecure: on',
#                                                'nfs.disable: true', ],
#                                 },
#                               },
#   }
#
# @author Scott Merrill <smerrill@covermymeds.com>
# @note Copyright 2014 CoverMyMeds, unless otherwise noted
#
class gluster (
  Optional[Boolean] $install_client,
  Optional[String] $client_package,
  Optional[String] $pool,
  Optional[Boolean] $repo,
  Optional[String] $release,
  Optional[Boolean] $install_server,
  Optional[String] $server_package,
  Optional[Boolean] $use_exported_resources,
  Optional[String] $version,
  Optional[String] $gluster_binary,
  Hash[String, Any] $volumes  = {},
) {
  class { 'gluster::install':
    install_server => $install_server,
    server_package => $server_package,
    install_client => $install_client,
    client_package => $client_package,
    version        => $version,
    repo           => $repo,
  }

  if $install_server {
    # if we installed the server bits, manage the service
    class { 'gluster::service':
      ensure => lookup('gluster::service_enable', Boolean, deep),
    }

    if $use_exported_resources {
      # first we export this server's instance
      @@gluster::peer { $facts['networking']['fqdn']:
        pool => $pool,
      }

      # then we collect all instances
      Gluster::Peer <<| pool == $pool |>>
    }

    $volumes.each |$volume, $options| {
      gluster::volume { $volume:
        * => $options,
      }
    }
  }
}
