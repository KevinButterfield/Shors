namespace Utilities
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    
    function ToResult (bit: Int) : (Result)
    {
        if 0 != bit { return One; } else { return Zero; }
    }

    operation Set (desired: Result, result: Qubit) : ()
    {
        body
        {
            let current = M(result);
            if desired != current
            {
                X(result);
            }
        }
    }

    operation Clear (register: Qubit[]) : ()
    {
        body
        {
            for(i in 0..Length(register)-1)
            {
                Set(Zero, register[i]);
            }
        }
    }

    operation SetInt(desired: Int, results: Qubit[]) : ()
    {
        body
        {
            for(i in 0..3) { Set(ToResult(desired &&& 2^i), results[i]); }
        }
    }

    operation QuantifySingle(classical: Int, quantum: Qubit, mask: Int) : ()
    {body{
        if 0 == (classical &&& mask)
        {
            Set(Zero, quantum);
        }
        else
        {
            Set(One, quantum);
        }
    }}

    operation Quantify(classical: Int, register: Qubit[]) : ()
    {
        body
        {
            for(i in 0..3) { QuantifySingle(classical, register[i], 2^i); }
        }
    }

    operation AddIfOne(q: Qubit, addendum: Int) : (Int)
    {body{
        mutable output = 0;
        if (One == M(q))
        {
            set output = addendum;
        }
        return output;
    }}

    operation Unquantify(register: Qubit[]) : (Int)
    {body{
        return AddIfOne(register[0], 1)
             + AddIfOne(register[1], 2)
             + AddIfOne(register[2], 4)
             + AddIfOne(register[3], 8);
    }}
}