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
  String $account_key,
  String $package_name            = 'scoutd',
  String $ensure                  = latest,
  Optional[String] $hostname      = $::facts['networking']['hostname'],
  Optional[String] $display_name  = undef,
  String $log_file                = '/var/log/scout/scoutd.log',
  Optional[String] $ruby_path     = undef,
  Optional[String] $environment   = undef,
  Array[String] $roles            = [],
  Optional[String] $http_proxy    = undef,
  Optional[String] $https_proxy   = undef,
  Boolean $statsd_enabled         = false,
  String $statsd_address          = '127.0.0.1:8125',
  Array[String] $gems             = [],
  String $gems_ensure             = latest,
  String $gem_provider            = 'gem',
  Boolean $service_enable         = true,
  String $service_ensure          = running,
  Optional[String] $plugin_pubkey = undef,
  Boolean $manage_repo            = true,
) {
  if $manage_repo {
    case $::facts['os']['family'] {
      'Debian': {
        apt::source { 'scout':
          location => 'https://archive.server.pingdom.com',
          key      => {
            id     => '705372CB1DF3976C44B7B8A6BBE475EBA38683E4',
            source => 'https://archive.server.pingdom.com/scout-archive.key',
          },
          release  => $::facts['os']['distro']['codename'],
          repos    => 'main',
        }
        Class['apt::update'] -> Package[$package_name]
      }
      'RedHat': {
        yumrepo { 'scout':
          baseurl => 'http://archive.server.pingdom.com/rhel/$releasever/main/$basearch/',
          gpgkey  => 'https://archive.server.pingdom.com/RPM-GPG-KEY-scout'
        }
        Yumrepo['scout'] -> Package[$package_name]
      }
      default: {
        fail("The operating system family ${::facts['os']['family']} is not supported by the puppet-scoutd module on ${::fqdn}")
      }
    }
  }

  package { $package_name:
    ensure => $ensure
  }

  service { 'scout':
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => Package[$package_name],
  }

  file { '/var/lib/scoutd':
    ensure  => directory,
    owner   => 'scoutd',
    group   => 'scoutd',
    require => Package[$package_name]
  }

  file { '/etc/scout/scoutd.yml':
    ensure  => present,
    owner   => 'scoutd',
    group   => 'scoutd',
    content => template('scoutd/scout.yml.erb'),
    require => Package[$package_name],
    notify  => Service['scout']
  }

  $plugin_pubkey_ensure = $plugin_pubkey? {
    undef   => absent,
    default => present,
  }
  file { 'scout_plugin_pub_key':
    ensure  => $plugin_pubkey_ensure,
    path    => '/var/lib/scoutd/scout_rsa.pub',
    content => $plugin_pubkey,
    owner   => 'scoutd',
    group   => 'scoutd',
    mode    => '0644',
    require => Package[$package_name],
  }

  # install any plugin gem dependencies
  package { $gems:
    ensure   => $gems_ensure,
    provider => $gem_provider,
  }
}
