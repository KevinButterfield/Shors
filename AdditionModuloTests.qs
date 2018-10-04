namespace DisabledTests
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

                Clear(a);
                Clear(b);
                Clear(N);
            }}}
        }
    }

    operation ModularDisjointUncertaintyWithSmallNTest () : ()
    {
        body
        {
            using (a = Qubit[4]) {
            using (b = Qubit[4]) {
            using (N = Qubit[4])
            {
                SetInt(6, N);

                Set(One, a[3]); // a = 1000
                Set(One, b[0]); // b = 0001

                H(a[1]); // a = 10?0
                H(b[2]); // b = 0?01

                AddMod(a, b, N); // b = 1??1

                AssertProb([PauliZ], [b[0]], One, 0.5, "b[0]", 1e-5);
                AssertProb([PauliZ], [b[1]], One, 0.5, "b[1]", 1e-5);
                AssertProb([PauliZ], [b[2]], One, 0.75, "b[2]", 1e-5);
                Assert([PauliZ], [b[3]], Zero, "b[3]");

                Clear(a);
                Clear(b);
                Clear(N);
            }}}
        }
    }

    operation ModularDisjointUncertaintyWithMiddleNTest () : ()
    {
        body
        {
            using (a = Qubit[4]) {
            using (b = Qubit[4]) {
            using (N = Qubit[4])
            {
                SetInt(11, N);

                Set(One, a[3]); // a = 1000
                Set(One, b[0]); // b = 0001

                H(a[1]); // a = 10?0
                H(b[2]); // b = 0?01

                AddMod(a, b, N); // b = 1??1 mod N

                // TODO: figure this out
                // AssertProb([PauliZ], [b[0]], One, 0.5, "b[0]", 1e-5);
                // AssertProb([PauliZ], [b[1]], One, 0.5, "b[1]", 1e-5);
                // AssertProb([PauliZ], [b[2]], One, 0.75, "b[2]", 1e-5);
                // Assert([PauliZ], [b[3]], Zero, "b[3]");

                Clear(a);
                Clear(b);
                Clear(N);
            }}}
        }
    }

    operation ModularMultipleJointUncertaintyTest () : ()
    {
        body
        {
            using (a = Qubit[4]) {
            using (b = Qubit[4]) {
            using (N = Qubit[4])
            {
                SetInt(12, N);

                H(a[2]);
                H(a[1]);
                Set(One, a[0]);
                // a = 0??1

                H(b[3]);
                H(b[1]);
                H(b[0]);
                // b = ?0??

                AddMod(a, b, N);

                AssertProb([PauliZ], [b[0]], One, 0.5, "b[0]", 1e-5);
                AssertProb([PauliZ], [b[1]], One, 0.5, "b[1]", 1e-5);
                AssertProb([PauliZ], [b[2]], One, 0.5, "b[2]", 1e-5);
                AssertProb([PauliZ], [b[3]], One, 0.5, "b[3]", 1e-5);

                Clear(a);
                Clear(b);
                Clear(N);
            }}}
        }
    }

}