namespace Addition
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Utilities;

    // Majority
    operation MAJ (top: Qubit, middle: Qubit, bottom: Qubit) : Unit
    {
        CNOT(bottom, middle);
        CNOT(bottom, top);
        CCNOT(top, middle, bottom);
    }
    operation MAJrev (top: Qubit, middle: Qubit, bottom: Qubit) : Unit
    {
        CCNOT(top, middle, bottom);
        CNOT(bottom, top);
        CNOT(bottom, middle);
    }

    // UnMajority and Add
    operation UMA (top: Qubit, middle: Qubit, bottom: Qubit) : Unit
    {
        CCNOT(top, middle, bottom);
        CNOT(bottom, top);
        CNOT(top, middle);
    }
    
    operation UMArev (top: Qubit, middle: Qubit, bottom: Qubit) : Unit
    {
        CNOT(top, middle);
        CNOT(bottom, top);
        CCNOT(top, middle, bottom);
    }

    // Result is stored in b
    operation AddWithOverflow (a: Qubit[], b: Qubit[], overflow: Qubit) : Unit
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

            CNOT(a[registerWidth], overflow);
            
            for(i in registerWidth..-1..1)
            {
                UMA(a[i-1], b[i], a[i]);
            }

            UMA(c[0], b[0], a[0]);

            // c should deterministically be Zero
        }
    }
    
    operation SubtractWithUnderflow (a: Qubit[], b: Qubit[], underflow: Qubit) : Unit
    {
        using (c = Qubit[1])
        {
            Set(Zero, c[0]);
            Set(Zero, underflow);
            let registerWidth = Length(a)-1;

            UMArev(c[0], b[0], a[0]);
            
            for(i in 1..registerWidth)
            {
                UMArev(a[i-1], b[i], a[i]);
            }

            CNOT(a[registerWidth], underflow);

            for(i in registerWidth..-1..1)
            {
                MAJrev(a[i-1], b[i], a[i]);
            }

            MAJrev(c[0], b[0], a[0]);

            // c should deterministically be Zero
        }
    }

    // b becomes b + a
    operation Add (a: Qubit[], b: Qubit[]) : Unit
    {
        using (overflow = Qubit[1])
        {
            AddWithOverflow(a, b, overflow[0]);
            Set(Zero, overflow[0]);
        }
    }

    // b becomes b - a
    operation Subtract (a: Qubit[], b: Qubit[]) : Unit
    {
        using (underflow = Qubit[1])
        {
            SubtractWithUnderflow(a, b, underflow[0]);
            Set(Zero, underflow[0]);
        }
    }
}
