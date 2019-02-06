class scoutd::install {

  assert_private()

  if $scoutd::manage_repo {
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
        Class['apt::update'] -> Package[$scoutd::package_name]
      }
      'RedHat': {
        yumrepo { 'scout':
          baseurl => 'http://archive.server.pingdom.com/rhel/$releasever/main/$basearch/',
          gpgkey  => 'https://archive.server.pingdom.com/RPM-GPG-KEY-scout'
        }
        Yumrepo['scout'] -> Package[$scoutd::package_name]
      }
      default: {
        fail("The operating system family ${::facts['os']['family']} is not supported by the puppet-scoutd module on ${::fqdn}")
      }
    }
  }

  package { $scoutd::package_name:
    ensure => $scoutd::ensure
  }

  # install any plugin gem dependencies
  package { $scoutd::gems:
    ensure   => $scoutd::gems_ensure,
    provider => $scoutd::gem_provider,
  }

}
