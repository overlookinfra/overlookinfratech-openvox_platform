# @summary Fix Postgresql selinux labels
#
# The vendor-supplied PostgreSQL packages set the selinux labels improperly
# which makes selinux deny permission to its unix socket. Foreman will still
# run properly if configured to use TCP pointed at `localhost`, but that leads
# to unnecessary memcopy overhead. This class applies the experimentally
# verified proper labels and allows use of the higher performance local socket.
#
# See https://www.postgresql.org/message-id/18462-2cb22ff14775b8f0@postgresql.org
#
# @example
#   include openvox_platform::selinux
class openvox_platform::selinux {
  require postgresql::globals
  $version = $postgresql::globals::globals_version

  # distro provided packages seem to be labeled properly.
  if $postgresql::globals::manage_package_repo {
    # deliberately omitting the parent bin directory
    selinux::fcontext{'postgresql-exec':
      seltype  => 'postgresql_exec_t',
      pathspec => "/usr/pgsql-${version}/bin/(.*)?",
      notify   => Selinux::Exec_restorecon['pgsql-bin'],
    }

    # so systemd can start it
    selinux::fcontext{'postmaster-exec':
      seltype  => 'bin_t',
      pathspec => "/usr/pgsql-${version}/bin/postmaster",
      notify   => Selinux::Exec_restorecon['pgsql-bin'],
    }

    selinux::exec_restorecon { 'pgsql-bin':
      path => "/usr/pgsql-${version}/bin/",
    }

#
## the rest of these appear to be labeled properly.
#
#     selinux::fcontext{'postgresql-data':
#       seltype  => 'postgresql_db_t',
#       pathspec => "/var/lib/pgsql/${version}/data(/.*)?",
#     }
#     selinux::fcontext{'postgresql-logs':
#       seltype  => 'postgresql_log_t',
#       pathspec => "/var/lib/pgsql/${version}/data/log(/.*)?",
#     }
#
#     selinux::fcontext{'postgresql-var':
#       seltype  => 'postgresql_var_run_t',
#       pathspec => "/var/run/postgresql(/.*)?",
#     }
#     selinux::fcontext{'postgresql-unit':
#       seltype  => 'systemd_unit_file_t',
#       pathspec => "/usr/lib/systemd/system/postgresql-${version}.service",
#     }
#
#     selinux::exec_restorecon { '/usr/pgsql-15/': }
#     selinux::exec_restorecon { '/var/lib/pgsql/': }
  }
}
