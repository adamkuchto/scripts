#!/usr/bin/env zsh

alias IP="sudo ip"

enableServer() {
	IP link set eth1 down
	IP link set eth2 down
	IP addr flush dev eth1
	IP addr add 10.127.1.40/24 dev eth1
	IP link set eth1 up
}

enableClient() {
	IP link set eth1 down
	IP link set eth2 down
	IP addr flush dev eth2
	IP addr add 10.127.1.60/24 dev eth2
	IP link set eth2 up
}

upServer() {
	IP link set eth1 up
}
upClient() {
	IP link set eth2 up
}

clean() {
	IP netns exec space ip link set dev ipVlanDevice netns 1
 	IP link delete ipVlanDevice
	IP link set eth1 down
	IP link set eth2 down
	IP addr flush dev eth1
	IP addr flush dev eth2
	pkill -9 iperf 
}

zparseopts -D -E -F -- \
	{s,-enableServer}=serverSettings \
	{c,-enableClient}=clientSettings \
	{upc,-upClient}=upClient \
	{ups,-upServer}=upServer \
	{d,-delete}=deleteSettings \
	|| exit 1

if (( $#serverSettings )); then
	enableServer
fi

if (( $#clientSettings )); then
	enableClient
fi

if (( $#upClient )); then
	upClient
fi

if (( $#upServer )); then
	upServer
fi

if (( $#deleteSettings )); then
	clean
fi

# sprawdzenie urządzeń na space
#	sudo ip netns exec space ip addr
