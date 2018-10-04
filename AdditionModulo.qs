namespace AdditionModulo
{
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Primitive;
    open Utilities;
    open Addition;

    operation AddMod(a: Qubit[], b: Qubit[], N: Qubit[]) : ()
    {body{
        using(t = Qubit[1])
        {
            AddWithOverflow(a, b, t[0]);
        }
    }}
}