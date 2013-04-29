from celery import Celery
from celery.task.control import inspect
from celery.utils import WORKER_DIRECT_QUEUE_FORMAT
import requests

celery = Celery('example')
celery.config_from_object('celeryconfig')

MONITORING_URL = "http://192.168.2.10/"

@celery.task
def nop():
    print "NOP"

@celery.task
def scattershot():
    requests.get(MONITORING_URL + "?scattershot")

@celery.task
def imalive():
    requests.get(MONITORING_URL + "?imalive")

@celery.task
def healthcheck():
    hosts = inspect().stats().keys()
    for host in hosts:
        queue = WORKER_DIRECT_QUEUE_FORMAT % host
        imalive.apply_async(queue=queue)
