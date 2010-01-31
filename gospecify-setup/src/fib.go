package fib

type Fib struct {
	N0, N1 int
}

func (state *Fib) Next() int {
	state.N0, state.N1 = state.N0 + state.N1, state.N0
	return state.N0
}
