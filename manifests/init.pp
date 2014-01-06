class avahialias {

  package { 'avahi-daemon': }

  package { 'python-avahi': }

  file { '/usr/local/sbin/avahi-alias.py':
    source => 'puppet:///modules/avahialias/avahi-alias.py',
  }

  file { '/etc/avahi/avahi-hosts':
    source => 'puppet:///modules/avahialias/avahi-hosts',
    require => Package['avahi-daemon'],
  }

  line { avahirclocal: 
    file => "/etc/rc.local",
    line => "/usr/local/sbin/avahi-alias.py `cat /etc/avahi/avahi-hosts` &",
  } 

}

define line($file, $line, $ensure = 'present') {
    case $ensure {
        default : { err ( "unknown ensure value ${ensure}" ) }
        present: {
            exec { "/bin/echo '${line}' >> '${file}'":
                unless => "/bin/grep -qFx '${line}' '${file}'"
            }
        }
        absent: {
            exec { "/usr/bin/perl -ni -e 'print unless /^\\Q${line}\\E\$/' '${file}'":
                onlyif => "/bin/grep -qFx '${line}' '${file}'"
            }
        }
    }
}
