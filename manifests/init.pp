# == Class: scoutd
#
# Installs and configures the scoutapp.com monitoring agent.
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
# Scout <support@scoutapp.com> (Derek Haynes)
#
# === Copyright
#
# Copyright 2013 Derek Haynes
#
class scoutd(
  $account_key,
  $hostname      = false,
  $display_name  = false,
  $log_file      = false,
  $ruby_path     = false,
  $environment   = false,
  $roles         = false,
  $http_proxy    = false,
  $https_proxy   = false,
  $gems          = false,
  $ensure        = present,
  $plugin_pubkey = ''
) {
  case $::operatingsystem {
      'Ubuntu': {
        apt::key { 'scout':
          key        => 'BA012E5E',
          key_source => 'https://archive.scoutapp.com/scout-archive.key',
        }

        apt::source { 'scout':
          location    => 'https://archive.scoutapp.com',
          include_src => false,
          release     => 'ubuntu',
          repos       => 'main',
          before      => Package['scoutd'],
          require     => Apt::Key['scout']
        }
      }
      'RedHat', 'CentOS': {
        yumrepo { 'scout':
          baseurl => 'http://archive.scoutapp.com/rhel/$releasever/main/$basearch/',
          gpgkey  => 'https://archive.scoutapp.com/RPM-GPG-KEY-scout'
        }
      }
      'Fedora': {
        yumrepo { 'scout':
          baseurl => 'http://archive.scoutapp.com/fedora/$releasever/main/$basearch/',
          gpgkey  => 'https://archive.scoutapp.com/RPM-GPG-KEY-scout'
        }
      }
      default: {
        fail("The operating system family ${::operatingsystem} is not supported by the puppet-scoutd module on ${::fqdn}")
      }
    }

    package { 'scoutd': ensure => latest }

    service { 'scout':
      ensure  => running,
      start   => 'scoutctl restart',
      require => Package['scoutd']
    }

    file { '/var/lib/scoutd':
      ensure  => directory,
      owner   => 'scoutd',
      group   => 'scoutd',
      require => Package['scoutd']
    }

    file { '/var/lib/scoutd/.scout':
      ensure  => directory,
      owner   => 'scoutd',
      group   => 'scoutd',
      require => File['/var/lib/scoutd']
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
        path    => '/var/lib/scoutd/.scout/scout_rsa.pub',
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
        ensure   => latest,
        provider => gem,
      }
    }
}
