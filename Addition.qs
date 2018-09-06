namespace Addition
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Utilities;

    // Majority
    operation MAJ (top: Qubit, middle: Qubit, bottom: Qubit) : ()
    {
        body
        {
            CNOT(bottom, middle);
            CNOT(bottom, top);
            CCNOT(top, middle, bottom);
        }
    }

    // UnMajority and Add
    operation UMA (top: Qubit, middle: Qubit, bottom: Qubit) : ()
    {
        body
        {
            CCNOT(top, middle, bottom);
            CNOT(bottom, top);
            CNOT(top, middle);
        }
    }

    // Result is stored in b
    operation AddWithOverflow (a: Qubit[], b: Qubit[], overflow: Qubit) : ()
    {
        body
        {
            using (c = Qubit[1])
            {
                Set(Zero, c[0]);
                Set(Zero, overflow);

                MAJ(c[0], b[0], a[0]);
                MAJ(a[0], b[1], a[1]);
                MAJ(a[1], b[2], a[2]);
                MAJ(a[2], b[3], a[3]);

                CNOT(a[3], overflow);

                UMA(a[2], b[3], a[3]);
                UMA(a[1], b[2], a[2]);
                UMA(a[0], b[1], a[1]);
                UMA(c[0], b[0], a[0]);

                // c should deterministically be Zero
            }
        }
    }

    operation Add (a: Qubit[], b: Qubit[]) : ()
    {
        body
        {
            using (overflow = Qubit[1])
            {
                AddWithOverflow(a, b, overflow[0]);
                Set(Zero, overflow[0]);
            }
        }
    }
}
