# == Class: scout
#
# Installs and configures the scoutapp.com monitoring agent.
#
# === Example
#
#  class { scout:
#    key => 'SCOUT ACCOUNT KEY HERE',
#    roles => ['app','memcached']
#  }
#
# === Authors
#
# Scout <support@scoutapp.com> (Derek Haynes)
#
# === Copyright
#
# Copyright 2013 Derek Haynes
#
class scout(
  $key,
  $bin = inline_template("<%= Gem.bindir%>/scout"),
  $gems = false,
  $ensure = present,
  $server_name = false,
  $roles = [],
  $environment = false,
  $http_proxy = false,
  $https_proxy = false,
  $user = 'scout',
  $group = 'scout',
  $plugin_pubkey = ''
) {
    # build the parameters for the scout command.
    if ($server_name) {
      $server_name_param = "--name ${server_name}"
    }

    if ($environment) {
      $environment_param = "-e ${environment}"
    }

    if ($roles != []) {
      $roles_param = inline_template("-r <%= @roles.join(',')%>")
    }

    if ($http_proxy) {
      $http_proxy_param = "--http-proxy ${http_proxy}"
    }

    if ($https_proxy) {
      $https_proxy_param = "--https-proxy ${https_proxy}"
    }

    if ($user != 'root') {
      if (!defined(Group[$group])) {
        group { $group:
              ensure => present,
              # gid => 1000
        }
      }

      if (!defined(User[$user])) {
        user { $user:
                ensure     => present,
                groups     => $group,
                gid        => $group,
                comment    => 'This user was created by Puppet',
                managehome => true,
                require    => Group[$group]
        }
        file { '/home/scout/.scout':
          ensure  => directory,
          owner   => $user,
          group   => $group,
          require => User[$user],
        }
      }
    }

    package { 'scout':
        ensure   => latest,
        provider => gem,
    }

    cron { 'scout':
        ensure  => $ensure,
        user    => $user,
        command => "${bin} ${key} ${environment_param} ${server_name_param} ${roles_param} ${http_proxy_param} ${https_proxy_param}",
        require => Package['scout'],
        hour    => '*',
        minute  => '*'
    }

    if ($plugin_pubkey != '') {
      file { 'scout_plugin_pub_key':
        ensure  => present,
        path    => "/home/${user}/.scout/scout_rsa.pub",
        content => $plugin_pubkey,
        owner   => $user,
        group   => $group,
        mode    => '0644',
        require => [Package['scout'], User[$user]],
      }
    }

    # install any plugin gem dependencies
    if $gems {
      if (!defined(Package[$gems])) {
        package { $gems:
            ensure   => latest,
            provider => gem,
        }
      }
    }
}
