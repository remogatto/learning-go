package main

import (
	"fmt"
	"reflect"
	"container/vector"
)

type task struct {
	name string
	block func()
	deps vector.Vector	
}

func Task(name string, block func()) (*task) {
	
	var t task

	t.name, t.block = name, block
	return &t
}

func (self task) String() (string) {

	return fmt.Sprintf("Task<name: %s, block: %s, deps: %s", self.name, self.block, self.deps)
}

func (self task) DependsOn(args ...) (*task) {

	v := reflect.NewValue(args).(*reflect.StructValue)

	for i := 0; i < v.NumField(); i++ {
		dep_name := (v.Field(i)).(*reflect.StringValue).Get()
		self.deps.Push(dep_name)
	}

	return &self
}

func main() {
	fmt.Println( Task("MyTask", func() {}).DependsOn("Task1", "Task2") )
}




