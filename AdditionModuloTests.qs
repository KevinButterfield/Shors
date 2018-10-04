namespace Tests
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Testing;
    open Utilities;
    open AdditionModulo;

    operation DeterministicModularAdditionTest () : ()
    {
        body
        {
            using (a = Qubit[4]) {
            using (b = Qubit[4]) {
            using (N = Qubit[4])
            {
                SetInt(6, a);
                SetInt(9, b);
                SetInt(10, N);

                // 6 + 9 mod 10 = 5
                AddMod(a, b, N);
                
                Assert([PauliZ], [b[0]], One, "b[0]");
                Assert([PauliZ], [b[1]], Zero, "b[1]");
                Assert([PauliZ], [b[2]], One, "b[2]");
                Assert([PauliZ], [b[3]], Zero, "b[3]");
            }}}
        }
    }
}