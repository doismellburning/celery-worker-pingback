

class example::base {
	$broker_ip = "192.168.2.10"

	package {
		"python-redis":
			ensure => present;
		"python-requests":
			ensure => present;
		"python-pip":
			ensure => present;
		"supervisor":
			ensure => present;
	}

	exec {
		"modern_celery":
			command => "/usr/bin/sudo pip install --download-cache=/root/pip/download_cache celery\\>=3",
			require => Package[python-pip]
	}

	$celery_dir = "/opt/celery"

	file {
		"celery-dir":
			ensure => "directory",
			require => Exec[modern_celery],
			path => "$celery_dir";
		"$celery_dir/celeryconfig.py":
			require => File[celery-dir],
			notify => Service[supervisor],
			content => template('example/config.py.erb');
		"$celery_dir/tasks.py":
			require => File[celery-dir],
			notify => Service[supervisor],
			source => "puppet:///modules/example/tasks.py";
	}

	service {
		"supervisor":
			require => Package[supervisor],
			ensure => running;
	}
}


class example::queue {
	package {
		"redis-server":
			ensure => present;
	}

	file {
		"/etc/redis/redis.conf":
			source => "puppet:///modules/example/redis.conf",
			require => Package[redis-server],
			notify => Service[redis-server];
	}

	service {
		"redis-server":
			require => Package[redis-server],
			ensure => running;
	}
}

class example::monitor {
	package {
		"apache2":
			ensure => present;
	}
}

class example::scheduler {
	file {
		"/etc/supervisor/conf.d/celerybeat.conf":
			content => template('example/celerybeat-supervisor.conf.erb'),
			require => Package[supervisor],
			notify => Service[supervisor];
	}
}

class example::worker {
	file {
		"/etc/supervisor/conf.d/celeryd.conf":
			content => template('example/celeryd-supervisor.conf.erb'),
			require => Package[supervisor],
			notify => Service[supervisor];
	}
}
