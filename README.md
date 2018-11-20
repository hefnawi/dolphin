<img src="http://orig03.deviantart.net/98f7/f/2015/217/3/d/bri_dee_by_kopica-d94efwh.png" height="95"><img src="https://www.pro-linux.de/images/NB3/imgdb/o_logo-von-kubernetes.jpg" height="95">

# dolphin
Highly Availabile Splash Cluster for crawling Javascript webpages using scrapy

## IN-PROGRESS

## TODO: Add k8s implementation

## Staging Environment

- Create encrypted password for docker-flow-proxy (must escape the `$` char like so: `$$` in the docker-compose file)

```
$ mkpasswd -m sha-512 testme
$6$WNNFqxU5G511h.Q$A/I6ciUHF7OhYvOWrFNCDZ1YbCbyxwkPbgtEHcZ9VnTG0abUq0Kbyn0VrLoQm8hLFB991ZVs254KnQnumJEQ50
```

- Provision manager/worker droplets using `docker-machine`, add as many as required

```
sudo docker-machine create --driver=digitalocean --digitalocean-image=ubuntu-16-04-x64 \
--digitalocean-monitoring=true --digitalocean-private-networking=true \
--digitalocean-region=fra1 --digitalocean-size=s-4vcpu-8gb \
--digitalocean-tags=backend,dolphin  \
--digitalocean-access-token=$DOTOKEN dolphin-staging-01
```

- SSH into one of the prospective manager machines
`sudo docker-machine ssh dolphin-staging-master`

- Once inside
`docker swarm init --advertise-addr node_ip_address`

- Run the output from the below command to join the rest of the manager nodes to the swarm
`docker swarm join-token manager`

- Create user defined overlay network
```
docker network create --driver overlay proxy
```

- Deploy the images using the stack deploy command
```
docker stack deploy -c docker-compose-stack.yml proxy
docker stack deploy -c docker-compose-splash.yml dolphin
```

## Initializing Swarm (TODO: create a Terraform config and/or Ansible role)

```
docker swarm init --advertise-addr <master-node-ip>

# run the output from this command on the other nodes to join as managers
docker swarm join-token manager

# run the output from this command on the other nodes to join as workers
docker swarm join-token worker

# create user-defined overlay network
docker network create --driver overlay proxy

# deploy the stack using the following docker-compose files
docker stack deploy -c docker-compose-stack.yml proxy
docker stack deploy -c docker-compose-splash.yml dolphin
```
