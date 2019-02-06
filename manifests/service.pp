class scoutd::service {

  assert_private()

  service { 'scout':
    ensure => $scoutd::service_ensure,
    enable => $scoutd::service_enable,
  }

}
