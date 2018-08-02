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

    operation DisjointUncertaintyTest () : ()
    {
        body
        {
            using (a = Qubit[4]) {
            using (b = Qubit[4])
            {
                Set(One, a[3]); // a = 1000
                Set(One, b[0]); // b = 0001

                H(a[1]); // a = 10?0
                H(b[2]); // b = 0?01

                Add(a, b); // b = 1??1

                Assert([PauliZ], [b[0]], One, "b[0] != 1");
                AssertProb([PauliZ], [b[1]], One, 0.5, "b[1] not 50/50", 1e-5);
                AssertProb([PauliZ], [b[2]], One, 0.5, "b[2] not 50/50", 1e-5);
                Assert([PauliZ], [b[3]], One, "b[3] != 1");

                Clear(a);
                Clear(b);
            }}
        }
    }

    operation SingleJointUncertaintyInIsolationTest () : ()
    {
        body
        {
            using (a = Qubit[4]) {
            using (b = Qubit[4])
            {
                H(a[0]); // a = 000?
                H(b[0]); // b = 000?

                Add(a, b);

                AssertProb([PauliZ], [b[0]], One, 0.5, "b[0]", 1e-5);
                AssertProb([PauliZ], [b[1]], One, 0.25, "b[1]", 1e-5);
                Assert([PauliZ], [b[2]], Zero, "b[2]");
                Assert([PauliZ], [b[3]], Zero, "b[3]");

                Clear(a);
                Clear(b);
            }}
        }
    }

    operation SingleJointUncertaintyWithOnesTest () : ()
    {
        body
        {
            using (a = Qubit[4]) {
            using (b = Qubit[4])
            {
                Set(One, a[2]);
                Set(One, a[1]);
                Set(One, b[2]);

                H(a[0]); // a = 011?
                H(b[0]); // b = 010?

                Add(a, b);

                AssertProb([PauliZ], [b[0]], One, 0.5, "b[0]", 1e-5);
                AssertProb([PauliZ], [b[1]], One, 0.75, "b[1]", 1e-5);
                AssertProb([PauliZ], [b[2]], One, 0.25, "b[2]", 1e-5);
                Assert([PauliZ], [b[3]], One, "b[3]");

                Clear(a);
                Clear(b);
            }}
        }
    }
}