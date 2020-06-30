class scoutd::config {

  assert_private()

  $dir_ensure = $scoutd::ensure? {
    absent   => absent,
    'absent' => absent,
    default  => directory,
  }
  file { '/var/lib/scoutd':
    ensure => $dir_ensure,
    force  => true,
    owner  => 'scoutd',
    group  => 'scoutd',
  }

  $file_ensure = $scoutd::ensure? {
    absent   => absent,
    'absent' => absent,
    default  => file,
  }
  file { '/etc/scout/scoutd.yml':
    ensure  => $file_ensure,
    owner   => 'scoutd',
    group   => 'scoutd',
    content => template('scoutd/scout.yml.erb'),
  }

  $plugin_pubkey_ensure = $scoutd::ensure? {
    absent   => absent,
    'absent' => absent,
    default  => $scoutd::plugin_pubkey? {
      undef   => absent,
      default => file,
    }
  }
  file { 'scout_plugin_pub_key':
    ensure  => $plugin_pubkey_ensure,
    path    => '/var/lib/scoutd/scout_rsa.pub',
    content => $scoutd::plugin_pubkey,
    owner   => 'scoutd',
    group   => 'scoutd',
    mode    => '0644',
  }
}
