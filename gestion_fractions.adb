with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Gestion_Fractions is

	procedure Get(F : out T_Fraction) is
	begin
		Get(F.Num);
		Get(F.Den);
		if F.Den = 0 then
			Put_Line("Le dénominateur ne peut être nul !");
			raise DIV_PAR_ZERO;
		end if;

		exception
			when others =>
				Put_line("Choix incorrect");
				Skip_Line;
				Get(F);
	end Get;

	procedure Put(F : in T_Fraction) is
	begin
		if F.Den = 1 then
			Put(Integer'Image(F.Num));
		else
			Put('(' & Integer'Image(F.Num) & " /" & Integer'Image(F.Den) & " )");
		end if;
	end Put;

	function PGCD(A : in Positive; B : in Positive) return Positive is
		I : Natural := A;
		J : Natural := B;
		R : Natural; -- reste
	begin
		if I < J then
			return PGCD(J, I);
		end if;

		loop
			R := I mod J;
			exit when R = 0;

			I := J;
			J := R;
		end loop;

		return J;
	end PGCD;

	function Reduire(F : in T_Fraction) return T_Fraction is
		Temp : Natural;
	begin
		if F.Num = 0 then
			return (0, 1);
		elsif F.Den < 0 then
			Temp := PGCD(F.Num, -F.Den);
			return ((-F.Num) / Temp, (-F.Den) / Temp); -- on met le (-) sur le dénominateur
		elsif F.Num < 0 and F.Den < 0 then
			Temp := PGCD(-F.Num, -F.Den);
			return ((-F.Num) / temp, (-F.Den) / Temp); -- pas besoin de (-)
		elsif F.Num < 0 then
			Temp := PGCD(-F.Num, F.Den);
		else
			Temp := PGCD(F.Num, F.Den);
		end if;

		return (F.Num / Temp, F.Den / Temp);
	end Reduire;

	function "+"(F : in T_Fraction; F2 : in T_Fraction) return T_Fraction is
	begin
		return Reduire( (F.Num * F2.Den + F2.Num * F.Den, F.Den * F2.Den) );
	end "+";

	function "-"(F : in T_Fraction; F2 : in T_Fraction) return T_Fraction is
	begin
		return F + (-F2.Num, F2.Den);
	end "-";
	function "-"(F : in T_Fraction) return T_Fraction is
	begin
		return (-F.Num, F.Den);
	end "-";

	function "*"(F : in T_Fraction; F2 : in T_Fraction) return T_Fraction is
	begin
		return Reduire( (F.Num * F2.Num, F.Den * F2.Den) );
	end "*";

	function "/"(F : in T_Fraction; F2 : in T_Fraction) return T_Fraction is
	begin
		if F2.Num = 0 then
			raise DIV_PAR_ZERO;
		end if;

		return F * (F2.Den, F2.Num);
	end "/";

	function "**"(F : in T_Fraction; p : in Natural) return T_Fraction is
		Temp : T_Fraction := F;
	begin
		for I in 1 .. p - 1 loop
			Temp := Temp * F;
		end loop;

		return Temp;
	end "**";


end Gestion_Fractions;