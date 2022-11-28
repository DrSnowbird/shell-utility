# Multi-Hops-SSH-Tunnels

## reference
[txoof/multi-hop-ssh.md](https://gist.github.com/txoof/5effd09613bd4e5a33654381cfb1efbc)

# Forward ports across multiple hosts to provide access to a remote machine

Configuration
[remote] --ssh--> [DMZ Host] --ssh--> [host on LAN]

This will map port localhost:8888 on the remote machine port 8888 on the DMZ host; then port 8888 on the DMZ host to port 8888 on the LAN host:

```
$ ssh -t -p 22 -l user_dmz host_dmz.com  -L 8888:localhost:8888  ssh -t -p 22 -l pi lan_host.local -L 8888:localhost:8888 
```
