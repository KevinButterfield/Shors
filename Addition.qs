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
                let registerWidth = Length(a)-1;

                MAJ(c[0], b[0], a[0]);

                for(i in 1..registerWidth)
                {
                    MAJ(a[i-1], b[i], a[i]);
                }

                CNOT(a[3], overflow);
                
                for(i in registerWidth..-1..1)
                {
                    UMA(a[i-1], b[i], a[i]);
                }

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
