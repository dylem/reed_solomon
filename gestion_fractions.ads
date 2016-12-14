package Gestion_Fractions is
	
	type T_Fraction is record
		Num : Integer;
		Den : Integer;
	end record;

	DIV_PAR_ZERO : exception;

	procedure Get(F : out T_Fraction);
	procedure Put(F : in T_Fraction);

	function PGCD(A : in Positive; B : in Positive) return Positive;	
	function Reduire(F : in T_Fraction) return T_Fraction;
	function "+"(F : in T_Fraction; F2 : in T_Fraction) return T_Fraction;
	function "-"(F : in T_Fraction; F2 : in T_Fraction) return T_Fraction;
	function "-"(F : in T_Fraction) return T_Fraction;
	function "*"(F : in T_Fraction; F2 : in T_Fraction) return T_Fraction;
	function "/"(F : in T_Fraction; F2 : in T_Fraction) return T_Fraction;
	function "**"(F : in T_Fraction; p : in Natural) return T_Fraction;


end Gestion_Fractions;