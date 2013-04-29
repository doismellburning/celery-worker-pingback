# Celery Worker Pingback without Broadcast Routing (snappier titles welcomed...)

Here's an example of a "healthcheck" task to ensure all Celery workers are processing jobs.

***UPDATE*** I thought this was neat because it didn't use broadcast routing so would work on non-amqp transports; turns out it uses a Celery feature that internally uses broadcast routing, and that Redis (which I was testing on) supports broadcast routing. So it's a bit moot really. You might find it interesting as a sample Vagrant / Celery project though!

It doesn't require the scheduler to have explicit knowledge of all workers, and it doesn't require broadcast task routing ([not all transports support fanout](http://kombu.readthedocs.org/en/latest/introduction.html#transport-comparison))

It does use dedicated worker queues ([CELERY_QUEUE_DIRECT](http://docs.celeryproject.org/en/latest/configuration.html#celery-worker-direct)) so needs Celery 3, which currently isn't packaged for Ubuntu, so the Puppet manifests use pip to fetch an updated Celery, resulting in slowness and pain (but faster and more convenient than a custom base box)

Thanks to [mcollective-vagrant](https://github.com/ripienaar/mcollective-vagrant) for a [Vagrant](http://www.vagrantup.com/) skeleton.
