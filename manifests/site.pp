exec {
	"apt-update":
		command => "/usr/bin/apt-get update";
}

Exec["apt-update"] -> Package <| |>

node base {
	include example::base
}

node /^worker/ inherits base {
	include example::worker
}

node /^scheduler/ inherits base {
	include example::queue
	include example::monitor
	include example::scheduler
}
