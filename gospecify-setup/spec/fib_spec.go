package main

import . "specify"
import t "../src/testfib"

func init() {
	Describe("Fib", func() {
		It("should return Fibonacci's next number", func(e Example) {
			fib := new(t.Fib)
			fib.N0, fib.N1 = 0, 1
			e.Value(fib.Next()).Should(Be(1))
			e.Value(fib.Next()).Should(Be(1))
			e.Value(fib.Next()).Should(Be(2))
			e.Value(fib.Next()).Should(Be(3))
			e.Value(fib.Next()).Should(Be(5))
		})

	})
}

