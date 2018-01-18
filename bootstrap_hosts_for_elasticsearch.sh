#!/bin/bash

# Use this script to bootstrap hosts before adding them to the Elasticsearch cluster.

# Switch off swap and increase vm.max_map_count
# References:
# See https://www.elastic.co/guide/en/elasticsearch/reference/current/setup-configuration-memory.html#disable-swap-files
# and https://www.elastic.co/guide/en/elasticsearch/reference/current/_maximum_map_count_check.html

# NOTE: This script updates root crontab.

echo "Starting to bootstrap ES hosts"

for i in `cat hosts`;
  do echo $i; echo "----";
    ssh $i 'echo -e "#!/bin/sh\nswapoff -a\nsysctl -w vm.max_map_count=262144" | sudo tee /var/local/setup_elasticsearch_env.sh'
    ssh $i 'sudo chmod a+x /var/local/setup_elasticsearch_env.sh'
    ssh $i '(crontab -l 2>/dev/null; echo "PATH=/bin:/sbin:/usr/bin:/usr/sbin"; echo "@reboot sh /var/local/setup_elasticsearch_env.sh") | sudo crontab -'
    ssh $i 'sudo /usr/sbin/reboot now'
  done

echo "Bootstrap complete"
exit 0
