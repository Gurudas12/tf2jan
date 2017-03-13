from testopia import Testopia
t2 = Testopia.from_config('/var/dt/tf/etc/testopia.cfg')
t2.testrun_get(63)
t2.environment_get(4)
