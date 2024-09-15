interface=enp0s3

staticIp="10.100.0.2"
mask="255.255.255.0"
gateway="10.100.0.1"
dns="8.8.8.8"

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
	ip addr flush dev $interface
	ip addr add $staticIp/$mask dev $interface
	ip route add default via $gateway
	echo "nameserver $dns" | tee /etc/resolv.conf > /dev/null
	echo "static ip configuration is done"
}

function configureDhcp() {
	dhclient -r $interface
	dhclient $interface
	echo "dynamic ip configuration has been applied"
}

while true; do
	echo "1) Display network card information"
	echo "2) Display current IP configuration"
	echo "3) Configure static IP"
	echo "4) Configure dynamic IP (DHCP)"
	echo "5) Exit"
	read -p "Choose an option: " choice

	case $choice in
		1) 
			networkInfo
			;;
		2) 
			currentIpConfig
			;;
		3)	
			configureStaticIp
			;;
		4) 
			configureDhcp
			;;
		5) 
			echo "Exiting script."
			exit 0
			;;
		*)
			echo "Invalid choice, try again"
			;;
	esac
done
