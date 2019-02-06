# == Class: scoutd
#
# Installs and configures the server.pingdom.com monitoring agent.
#
# === Example
#
#  class { scoutd:
#    key => 'SCOUT ACCOUNT KEY HERE',
#    roles => ['app','memcached']
#  }
#
# === Authors
#
# Scout <support@server.pingdom.com> (Andre Lewis)
#
# === Copyright
#
# Copyright 2013 Andre Lewis
#
class scoutd(
  $account_key,
  $hostname       = false,
  $display_name   = false,
  $log_file       = false,
  $ruby_path      = false,
  $environment    = false,
  $roles          = false,
  $http_proxy     = false,
  $https_proxy    = false,
  $statsd_enabled = false,
  $statsd_address = false,
  $gems           = false,
  $gems_ensure    = latest,
  $ensure         = latest,
  $plugin_pubkey  = ''
) {
  case $::operatingsystem {
      'Ubuntu': {
        apt::key { 'scout':
          key        => '705372CB1DF3976C44B7B8A6BBE475EBA38683E4',
          key_source => 'https://archive.server.pingdom.com/scout-archive.key',
        }

        case $::operatingsystemmajrelease {
          /^18/: {
            $release = 'bionic'
          }
          /^17/: {
            $release = 'zesty'
          }
          /^16/: {
            $release = 'xenial'
          }
          /^15/: {
            $release = 'vivid'
          }
          /^1[0-4]/: {
            $release = 'ubuntu'
          }
          default: {
            fail("${::operatingsystemmajrelease} is an unsupported version of Ubuntu on ${::fqdn}")
          }
        }
        apt::source { 'scout':
          location    => 'https://archive.server.pingdom.com',
          include_src => false,
          release     => $release,
          repos       => 'main',
          before      => Package['scoutd'],
          require     => Apt::Key['scout']
        }
      }
      'Debian': {
        apt::key { 'scout':
          key        => '705372CB1DF3976C44B7B8A6BBE475EBA38683E4',
          key_source => 'https://archive.server.pingdom.com/scout-archive.key',
        }

        case $::operatingsystemmajrelease {
          8: {
            $release = 'jessie'
          }
          7: {
            $release = 'wheezy'
          }
          default: {
            fail("${::operatingsystemmajrelease} is an unsupported version of Debian on ${::fqdn}")
          }
        }
        apt::source { 'scout':
          location    => 'https://archive.server.pingdom.com',
          include_src => false,
          release     => $release,
          repos       => 'main',
          before      => Package['scoutd'],
          require     => Apt::Key['scout']
        }

      }
      'RedHat', 'CentOS': {
        yumrepo { 'scout':
          baseurl => 'http://archive.server.pingdom.com/rhel/$releasever/main/$basearch/',
          gpgkey  => 'https://archive.server.pingdom.com/RPM-GPG-KEY-scout'
        }
      }
      'Fedora': {
        yumrepo { 'scout':
          baseurl => 'http://archive.server.pingdom.com/fedora/$releasever/main/$basearch/',
          gpgkey  => 'https://archive.server.pingdom.com/RPM-GPG-KEY-scout'
        }
      }
      default: {
        fail("The operating system family ${::operatingsystem} is not supported by the puppet-scoutd module on ${::fqdn}")
      }
    }

    package { 'scoutd': ensure => $ensure }

    service { 'scout':
      ensure  => running,
      start   => 'scoutctl restart',
      status  => 'scoutctl status',
      require => Package['scoutd']
    }

    file { '/var/lib/scoutd':
      ensure  => directory,
      owner   => 'scoutd',
      group   => 'scoutd',
      require => Package['scoutd']
    }

    file { '/etc/scout/scoutd.yml':
      ensure  => present,
      owner   => 'scoutd',
      group   => 'scoutd',
      content => template('scoutd/scout.yml.erb'),
      require => Package['scoutd'],
      notify  => Service['scout']
    }

    if ($plugin_pubkey != '') {
      file { 'scout_plugin_pub_key':
        ensure  => present,
        path    => '/var/lib/scoutd/scout_rsa.pub',
        content => $plugin_pubkey,
        owner   => 'scoutd',
        group   => 'scoutd',
        mode    => '0644',
        require => Package['scoutd'],
      }
    }

    # install any plugin gem dependencies
    if $gems {
      package { $gems:
        ensure   => $gems_ensure,
        provider => gem,
      }
    }
}
