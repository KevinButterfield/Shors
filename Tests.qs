namespace TestAdd
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Testing;
    open Addition;

    operation AssertEq (expected: Int, actual: Qubit[]) : ()
    {
        body
        {
            for(i in 0..3)
            {
                AssertQubit(ToResult(expected &&& 2^i), actual[i]);
            }
        }
    }

    operation DeterministicAdditionTest () : ()
    {
        body
        {
            using (a = Qubit[4]) {
            using (b = Qubit[4])
            {
                Add(a, b);

                AssertAllZero(b); // Here to test my test framework, mainly
                AssertEq(0, b);
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