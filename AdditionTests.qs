namespace Tests
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Extensions.Testing;
    open Utilities;
    open Addition;

    operation AssertEq (expected: Int, actual: Qubit[], message: String) : Unit
    {
        for(i in 0..3)
        {
            Assert([PauliZ], [actual[i]], ToResult(expected &&& 2^i), $"{message} [{i}]");
        }
    }

    operation SetAndTest(a: Int, qa: Qubit[], b: Int, qb: Qubit[]) : Unit
    {
        SetInt(a, qa);
        SetInt(b, qb);
        Add(qa, qb);
        AssertEq(a + b, qb, $"{a}+{b}={a+b}");
    }

    operation DeterministicAdditionTest () : Unit
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

    operation DisjointUncertaintyTest () : Unit
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

    operation BasicDeterministicSubtractionTest () : Unit
    {
        using (a = Qubit[4]) {
        using (b = Qubit[4])
        {
            Set(One, b[3]);
            Set(One, b[2]);
            Set(One, b[1]);
            Set(One, b[0]);
            // b = 1111

            Set(One, a[2]);
            Set(One, a[0]);
            // a = 0101

            Subtract(a, b);

            AssertEq(10, b, "");

            Clear(a);
            Clear(b);
        }}
    }

    operation BasicUncertainSubtractionTest () : Unit
    {
        using (a = Qubit[4]) {
        using (b = Qubit[4])
        {
            Set(One, a[3]);
            // a = 1000

            Set(One, b[3]);
            H(b[1]);
            H(b[0]);
            // b = 10??
            
            Subtract(a, b);

            AssertProb([PauliZ], [b[0]], One, 0.5, "b[0]", 1e-5);
            AssertProb([PauliZ], [b[1]], One, 0.5, "b[1]", 1e-5);
            Assert([PauliZ], [b[2]], Zero, "b[2]");
            Assert([PauliZ], [b[3]], Zero, "b[3]");

            Clear(a);
            Clear(b);
        }}
    }

    operation ComplexUncertainSubtractionTest () : Unit
    {
        using (a = Qubit[4]) {
        using (b = Qubit[4])
        {
            H(a[2]);
            H(a[1]);
            // a = 0??0

            Set(One, b[3]);
            H(b[1]);
            // b = 10?0
            
            Subtract(a, b);

            Assert([PauliZ], [b[0]], Zero, "b[0]");
            AssertProb([PauliZ], [b[1]], One, 0.5, "b[1]", 1e-5);
            AssertProb([PauliZ], [b[2]], One, 0.5, "b[2]", 1e-5);
            AssertProb([PauliZ], [b[3]], One, 0.375, "b[3]", 1e-5);

            Clear(a);
            Clear(b);
        }}
    }

    operation UnderflowIndicatesSubtractionWentNegativeTest () : Unit
    {
        using (a = Qubit[4]) {
        using (b = Qubit[4]) {
        using (u = Qubit[4])
        {
            Set(One, b[2]);
            Set(One, b[0]);
            // b = 0101
            
            Set(One, a[3]);
            // a = 1000

            SubtractWithUnderflow(a, b, u[0]);

            Assert([PauliZ], [u[0]], One, "u");
            
            Clear(a);
            Clear(b);
            Clear(u);
        }}}
    }

    operation SingleJointUncertaintyInIsolationTest () : Unit
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

    operation SingleJointUncertaintyWithOnesTest () : Unit
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

    operation MiddleNonHalfTest () : Unit
    {
        using (a = Qubit[4]) {
        using (b = Qubit[4])
        {
            H(a[2]);
            H(a[0]);
            // a = 0?0?

            Set(One, b[1]);
            H(b[0]);
            // b = 001?

            Add(a, b);

            AssertProb([PauliZ], [b[0]], One, 0.5, "b[0]", 1e-5);
            AssertProb([PauliZ], [b[1]], One, 0.75, "b[1]", 1e-5);
            AssertProb([PauliZ], [b[2]], One, 0.5, "b[2]", 1e-5);

            Clear(a);
            Clear(b);
        }}
    }

    operation MultipleJointUncertaintyTest () : Unit
    {
        using (a = Qubit[4]) {
        using (b = Qubit[4]) {
        using (c = Qubit[1])
        {
            H(a[2]);
            H(a[1]);
            Set(One, a[0]);
            // a = 0??1

            H(b[3]);
            H(b[1]);
            H(b[0]);
            // b = ?0??

            AddWithOverflow(a, b, c[0]);

            AssertProb([PauliZ], [b[0]], One, 0.5, "b[0]", 1e-5);
            AssertProb([PauliZ], [b[1]], One, 0.5, "b[1]", 1e-5);
            AssertProb([PauliZ], [b[2]], One, 0.5, "b[2]", 1e-5);
            AssertProb([PauliZ], [b[3]], One, 0.5, "b[3]", 1e-5);
            AssertProb([PauliZ], [c[0]], One, 0.125, "c[0]", 1e-5);

            Clear(a);
            Clear(b);
            Clear(c);
        }}}
    }

    operation MoreThanFourBitsTest () : Unit
    {
        using (a = Qubit[6]) {
        using (b = Qubit[6]) {
        using (c = Qubit[1])
        {
            Set(One, a[5]);
            Set(One, a[3]);
            Set(One, a[1]);
            // a = 101010

            Set(One, b[4]);
            Set(One, b[2]);
            Set(One, b[0]);
            // b = 010101

            AddWithOverflow(a, b, c[0]);

            Assert([PauliZ], [b[0]], One, "b[0]");
            Assert([PauliZ], [b[1]], One, "b[1]");
            Assert([PauliZ], [b[2]], One, "b[2]");
            Assert([PauliZ], [b[3]], One, "b[3]");
            Assert([PauliZ], [b[4]], One, "b[4]");
            Assert([PauliZ], [b[5]], One, "b[5]");
            Assert([PauliZ], [c[0]], Zero, "c[0]");

            Clear(a);
            Clear(b);
            Clear(c);
        }}}
    }
}