
with gestion_fractions; use gestion_fractions;

package Gestion_Polynomes is
	subtype T_Degre is Natural range 0 .. 10000;
	type T_Coeff is array(T_Degre range <>) of T_Fraction;
	type T_Polynome(Degre : T_Degre := 0) is record
		Coeff : T_Coeff(0 .. Degre);
	end record;

	procedure Get(P : out T_Polynome; Degre : in T_Degre);
	procedure Put(P : in T_Polynome);
	function Reduire_Degre(P : in T_Polynome) return T_Polynome;

	function "+"(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome;
	function "-"(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome;
	function "*"(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome;
	function "/"(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome;

	function Reste(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome;
	function Eval(P : in T_Polynome; F : in T_Fraction) return T_Fraction;
	function Alloc_Polyn(N : T_Degre) return T_Polynome;

end Gestion_Polynomes;