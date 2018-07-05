namespace TestAdd
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;

    operation AllocateQubitTest () : ()
    {
        body
        {
            using (qs = Qubit[1])
            {
                Assert([PauliZ], [qs[0]], Zero, "Newly allocated qubit must be in |0> state");
            }
            
            Message("Test passed");
        }
    }
}