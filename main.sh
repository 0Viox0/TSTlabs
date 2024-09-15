interface=enp0s3

function networkInfo() {
	echo "Network card model and vendor:"
	lshw -C network | grep "vendor"
	lshw -C network | grep "product"

	echo "Channel speed:"
	ethtool $interface | grep "Speed"

	echo "Duplex mode:"
	ethtool $interface | grep "Duplex"

	echo "Physical connection (link status):"
	ethtool $interface | grep "Link detected"

	echo "Mac address: "
	echo "        $(ip link show enp0s3 | grep ether | awk '{print $2}')"
}

function currentIpConfig() {
	echo "Ipv4 configuration:"
	ip addr show $interface

	echo "Gateway:"
	ip route | grep default | awk '{print $3}'

	echo "DNS Server(s):"
	cat /etc/resolv.conf | grep "nameserver"
}

function configureStaticIp() {

}

currentIpConfig
