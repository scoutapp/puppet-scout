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

  contain scoutd::install
  contain scoutd::config
  contain scoutd::service

  Class['scoutd::install']
  -> Class['scoutd::config']
  ~> Class['scoutd::service']
}
