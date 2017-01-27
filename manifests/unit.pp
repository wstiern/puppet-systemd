define systemd::unit (
	Boolean $ensure = true,
	Boolean $managed = false,
	Boolean $enable = true,
	$unit_description = undef,
	$unit_documentation = undef,
	$unit_after = [ "syslog.target", "network.target" ],
	$cond_path_exists = undef,
	$environment = undef,
	$syslog_identifier = undef,
	$work_directory = undef,
	$user = undef,
	$group = undef,
	$unit_requires = undef,
	$unit_wants = undef,
	$unit_conflicts = undef,
	$unit_defaultdependencies = undef,
	$unit_bindsto = undef,
	# Unit type is one of: automount,freedesktop,mount,path,service,slice,socket,target,timer
	$unit_type = "service",
	# Service type can one of: simple,forking,oneshot,notify,dbus,idle
	$service_type = "simple",
	$service_busname = undef,
	$service_remainafterexit = undef,
	$service_guessmainpid = undef,
	$service_pidfile = undef,
	$service_execstart = undef,
	$service_execstartpre = undef,
	$service_execstartpost = undef,
	$service_execstop = undef,
	$service_execstoppost = undef,
	$service_execreload = undef,
	$service_restart = undef,
	$service_restartsec = undef,
	$service_timeoutstartsec = undef,
	$service_timeoutstopsec = undef,
	$service_timeoutsec = undef,
	$service_runtimemaxsec = undef,
	$service_watchdogsec = undef,
	$service_successexitstatus = undef,
	$service_restartpreventexitstatus = undef,
	$service_restartforceexitstatus = undef,
	$service_permissionsstartonly = undef,
	$service_rootdirectorystartonly = undef,
	$service_nonblocking = undef,
	$service_notifyaccess = undef,
	$service_sockets = undef,
	$service_failureaction = undef,
	$service_filedescriptorstoremax = undef,
	$service_usbfunctiondescriptors = undef,
	$service_usbfunctionstrings = undef,
	$service_standardoutput = undef,
	$service_standarderror = undef,
	$install_alias = undef,
	$install_requiredby = undef,
	$install_wantedby = [ "multi-user.target" ],
	$install_also = undef,
	$install_defaultinstance = undef,
)
{

	case $unit_type {

		/service/: {

			$file_ensure = $ensure ? {
				true	=> file,
				default	=> absent,
			}

			file { "/etc/systemd/system/${title}.${unit_type}":
				ensure	=> $file_ensure,
				owner	=> 'root',
				group	=> 'root',
				mode	=> '0644',
				content	=> template("systemd/unit.erb"),
				notify	=> Exec["systemd-daemon-reload-${title}.${unit_type}"],
			} 
			if $managed {
				service { "${title}":
					ensure		=> $ensure,
					enable		=> $enable,
				}
			}

		}

		default: {}

	}

	exec { "systemd-daemon-reload-${title}.${unit_type}":
		command		=> '/bin/systemctl daemon-reload',
		refreshonly	=> true,
	}

}
