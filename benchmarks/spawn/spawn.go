package main

import (
	"fmt"
	"time"
	"flag"
	"strconv"
)

func main() {
	flag.Parse()
	num_processes, _ := strconv.Atoi(flag.Arg(0))

	done := make(chan bool)

	start := time.Nanoseconds()

	for i := 0; i < num_processes; i++ {
		go func() {
			done <- true
		}()
	}

	end := time.Nanoseconds()

	total_spawn_time_us := float((end - start) / 10E3)
	process_spawn_time := total_spawn_time_us / float(num_processes)

	fmt.Print(process_spawn_time)

	for i := 0; i < num_processes; i++ { <-done }
}
