namespace TestAdd
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Testing;
    open Addition;

    operation AssertEq (expected: Int, actual: Qubit[], message: String) : ()
    {
        body
        {
            for(i in 0..3)
            {
                Assert([PauliZ], [actual[i]], ToResult(expected &&& 2^i), $"{message} [{i}]");
            }
        }
    }

    operation SetAndTest(a: Int, qa: Qubit[], b: Int, qb: Qubit[]) : ()
    {
        body
        {
            SetInt(a, qa);
            SetInt(b, qb);
            Add(qa, qb);
            AssertEq(a + b, qb, $"{a}+{b}={a+b}");
        }
    }

    operation DeterministicAdditionTest () : ()
    {
        body
        {
            using (a = Qubit[4]) {
            using (b = Qubit[4])
            {
                SetAndTest(3,  a, 5, b);
                SetAndTest(1,  a, 14, b);
                SetAndTest(7,  a, 7,  b);
                SetAndTest(15, a, 0,  b);
                SetAndTest(0,  a, 0,  b);
            }}
        }
    }

    operation AllocateQubitTest () : ()
    {
        body
        {
            using (qs = Qubit[1])
            {
                Assert([PauliZ], qs, Zero, "Newly allocated qubit must be in |0> state");
            }
            
            Message("Test passed");
        }
    }
}