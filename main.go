package main

import (
	"bufio"
	"net"
	"os"
	"path"
)

func main() {
	listener, err := net.Listen("tcp", ":8081")
	check(err)

	for {
		connection, err := listener.Accept()
		check(err)
		connection.Write([]byte(getSelfId() + "\n"))
		connection.Close()
	}
}

func check(error error) {
	if error != nil {
		panic(error)
	}
}

func getSelfId() string {
	file, err := os.Open("/proc/1/cgroup")
	check(err)
	defer file.Close()

	buffer := bufio.NewReader(file)
	var line string
	line, err = buffer.ReadString('\n')
	check(err)

	return path.Base(line)
}