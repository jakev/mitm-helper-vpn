# PPTP VPN Man-in-the-Middle Helper

## About
These scripts are designed to make it easy and straight-forward to configure a Ubuntu virtual machine to act as a PPTP VPN endpoint, and forward traffic to your favorite web proxy or other tool. I personally use this for doing mobile testing, as both Android and iOS support PPTP VPNs out of the box.

*Note: There is no black magic here - simply some utilities to make it easier to use.*

The typical work flow would be a VM that has one interface, we'll call it 'eth0'. First, we start the `pptpd` daemon and then we configure IP forwarding and apply custom `iptables` rules to forward traffic to specific proxies, such as Burp.

## Configuration
This tool is designed to work on Ubuntu virtual machines operating in 'bridged' mode. Your mileage will vary if you use another VM, but I suppose Kali Linux should also work fine.

To download and setup the tool, run the following commands:

    $ git clone https://github.com/jakev/mitm-helper-vpn
    $ cd mitm-helper-vpn
    $ sudo ./install_dependencies.sh
    $ sudo dpkg -i build/mitm-helper-vpn_0.1.deb

### Managing Users
First, we need to add a user. This example will add a user called 'analyst', with a password of 'analyst':

    $ sudo mitm-pptp-users add analyst analyst

If you want to see your current users:

    $ sudo mitm-pptp-users list

To delete a user:

    $ sudo mitm-pptp-users del analyst

To delete all users:

    $ sudo mitm-pptp-users purge

### Configuring Proxy Rules
The file `/etc/mitm-pptp.conf` will be used to configure how you will intercept traffic. By default, traffic is simply passed through (no proxy). This should work if you just want to observe traffic using a tool like Wireshark. In our case, let's assume we have Burp running on port 9999, and we'd like to forward traffic on ports 80 and 443 to this proxy. We configure the `/etc/mitm-pptp.conf` file as follows:

```
[HTTP Proxies]
ProxyPort:9999
ForwardPorts:80,443
```

Now, let's say that we determine our app/device uses a custom protocol on port 1234, and Burp is not useful for intercepting this traffic. We created a python script, and it is listening on port 8888. Let's add rules for this:

```
[HTTP Proxies]
ProxyPort:9999
ForwardPorts:80,443

[Binary Coolness Proxy]
ProxyPort:8888
ForwardPorts:1234
```

This configuration can be found in the file `sample.mitm-pptp.conf`.

#### Starting the VPN
By default, the PPTP server will be disabled and no forwarding will happen. Once you're ready to start, run:

    $ sudo mitm-pptp -v

If you want to specify a custom configuration file, you can do so with the `-c` argument:

    $ sudo mitm-pptp -v -c my-pptp.conf

### Stopping the VPN
By hitting Ctrl+C, the script will begin the shutdown process.
