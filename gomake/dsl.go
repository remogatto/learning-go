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

var tasks map [string] *task

func Task(name string, block func()) (*task) {
	
	var t task

	t.name, t.block = name, block
	tasks[name] = &t

	return &t
}

func (self task) String() (string) {

	return fmt.Sprintf("Task<name: %s, block: %s, deps: %s", self.name, self.block, self.deps)
}

func (self task) DependsOn(args ...) (*task) {

	v := reflect.NewValue(args).(*reflect.StructValue)
	for i := 0; i < v.NumField(); i++ { self.deps.Push((v.Field(i)).(*reflect.StringValue).Get()) }

	return &self
}

func (self task) Invoke() (*task) {

	self.deps.Do(func (el interface{}) { tasks[el.(string)].Invoke() })
	self.block()

	return &self
}

func init() { tasks = make(map [string] *task) }

func main() {
	Task("MyTask1", func () { 
		fmt.Println("Hello World from MyTask1!")
	})
	Task("MyTask2", func () { 
		fmt.Println("Hello World from MyTask2!")
	}).DependsOn("MyTask1").Invoke()
}

