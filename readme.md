# birdspark

Simple envornment for learning and testing [bird](https://bird.network.cz/).

# Task 0. "Flatwhite"

## Topology
3 logical "nodes": moscow, samara, phuket. Actually containers with shared bridge network 192.168.50.0/24.
Every node have dummy interface "dummmy0" with own network (/24 cidr).


containers:
- moscow:
    local address = 192.168.50.110
    own network   = 10.0.10.0/24
- samara:
    local address = 192.168.50.120
    own network   = 10.0.20.0/24
- phuket:
    local address = 192.168.50.120
    own network   = 10.0.30.0/24

## Goal
Goal of this task - simple exchange route information about dummy interfaces between nodes

## OSPF solution

quick start:
```
make ospf
```

results:
```
> docker compose exec moscow ip r
default via 192.168.50.1 dev eth0 
10.0.10.0/24 dev dummy0 scope link  src 10.0.10.1 
10.0.10.0/24 dev dummy0 scope link  metric 32 
10.0.20.0/24 via 192.168.50.120 dev eth0  metric 32 
10.0.30.0/24 via 192.168.50.130 dev eth0  metric 32 
192.168.50.0/24 dev eth0 scope link  src 192.168.50.110 
192.168.50.0/24 dev eth0 scope link  metric 32 


> docker compose exec moscow birdc show r  
BIRD 2.15.1 ready.
Table master4:
10.0.30.0/24         unicast [ospf1 19:26:54.889] * E2 (150/5/10000) [192.168.50.130]
        via 192.168.50.130 on eth0
10.0.20.0/24         unicast [ospf1 19:26:54.889] * E2 (150/5/10000) [192.168.50.120]
        via 192.168.50.120 on eth0
192.168.50.0/24      unicast [ospf1 19:26:54.889] * I (150/5) [192.168.50.130]
        dev eth0
10.0.10.0/24         unicast [direct1 19:26:39.795] * (240)
        dev dummy0

> docker compose exec moscow birdc show ospf top
BIRD 2.15.1 ready.

area 0.0.0.0

        router 192.168.50.110
                distance 0
                network 192.168.50.0/24 metric 5

        router 192.168.50.120
                distance 5
                network 192.168.50.0/24 metric 5

        router 192.168.50.130
                distance 5
                network 192.168.50.0/24 metric 5

        network 192.168.50.0/24
                dr 192.168.50.130
                distance 5
                router 192.168.50.130
                router 192.168.50.110
                router 192.168.50.120
```