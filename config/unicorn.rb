@dir = '/home/services/site_services/current/'

worker_processes 2
working_directory @dir

timeout 30

listen '/var/run/unicorn/site_services.sock', :backlog => 64

pid '/var/run/unicorn/site_services.pid'

stderr_path '/var/log/unicorn/site_services_error.log'
stdout_path '/var/log/unicorn/site_services.log'