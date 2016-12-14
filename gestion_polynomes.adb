with Text_IO; use Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body Gestion_Polynomes is

	procedure Get(P : out T_Polynome; Degre : in T_Degre) is
	begin
		for I in P.Coeff'Range loop
			Put("x ^" & Integer'Image(I) & " : ");
			Get(P.Coeff(I));
		end loop;
	end Get;

	procedure Put(P : in T_Polynome) is
	begin
		for I in P.Coeff'Range loop
			if not (P.Coeff(I).Num = 0) then
				if not (P.Coeff(I) = (1, 1)) or (I = 0) then -- P(I) != 1 * x ^ n (n != 0)
					Put(P.Coeff(I));
				end if;
				if I > 0 then
					Put("(x ^" & Integer'Image(I) & (")"));
				end if;
				if I < P.Degre then
					Put(" + ");
				end if;
			end if;
		end loop;
	end Put;

	function Reduire_Degre(P : in T_Polynome) return T_Polynome is
		Result : T_Polynome;
		N : Natural := 0; -- degré à retirer
	begin
		for J in reverse P.Coeff'Range loop -- à chaque fois que le dernier coeff est 0, on rajoute 1 à N
			if P.Coeff(J).Num = 0 then
				N := N + 1;
			else
				exit;
			end if;
		end loop;

		if (N - 1) = P.Degre and P.Coeff(0).Num = 0 then -- si tous les coeffs sont égaux
			return (Degre => 0, Coeff => (others => (1, 1))); -- polynome de degré 0 : 1/1
		end if;
		if N > 0 then
			Result := (Degre => P.Degre - N, Coeff => (others => (0, 1))); -- on enlève les coeffs en trop

			for I in Result.Coeff'Range loop
				Result.Coeff(I) := P.Coeff(I);
			end loop;
			return Result; -- on retourne le résultat avec les problèmes de coeffs résolus
		end if;
		return P;
	end Reduire_Degre;

	function "+"(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome is
		Result : T_Polynome(P.Degre);
	begin
		if P.Degre < P2.Degre then -- P est toujours le plus grand
			return P2 + P;
		end if;

		for I in P.Coeff'Range loop
			if I in P2.Coeff'Range then
				Result.Coeff(I) := P.Coeff(I) + P2.Coeff(I);
			else
				Result.Coeff(I) := P.Coeff(I);
			end if;
		end loop;

		return Reduire_Degre(Result); -- sinon on retourne le résultat
	end "+";

	function "-"(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome is
		Temp : T_Polynome := P2;
	begin
		for I in Temp.Coeff'Range loop
			Temp.Coeff(I) := -Temp.Coeff(I);
		end loop;

		return P + Temp;
	end "-";

	function "*"(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome is
		Result : T_Polynome := (Degre => P.Degre + P2.Degre, Coeff => (others => (0, 1))); -- De la taille maximale, soit Pmax * P2max
	begin
		for I in P.Coeff'Range loop
			for J in P2.Coeff'Range loop
				Result.Coeff(I + J) := Result.Coeff(I + J) + (P.Coeff(I) * P2.Coeff(J));
			end loop;
		end loop;

		return Result;
	end "*";

	-- méthode des puissances décroissantes
	function "/"(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome is
		Q : T_Polynome; -- Quotient
		R : T_Polynome; -- Reste
		P_R : T_Polynome := Reduire_Degre(P); -- P Réduit
		P_R2 : T_Polynome := Reduire_Degre(P2); -- P2 Réduit
	begin
		if P_R.Degre < P_R2.Degre then -- R = P_R
			return (Degre => 0, Coeff => (others => (0, 1)));
		elsif P_R2.Degre = 0 then -- R = 0
			Q := (Degre => P_R.Degre, Coeff => (others => (0, 1)));
			for I in P_R.Coeff'Range loop
				Q.Coeff(I) := P_R.Coeff(I) / P_R2.Coeff(0);
			end loop;
			return Q;
		end if;

		Q := (Degre => (P_R.Degre - P_R2.Degre), Coeff => (others=>(0,1)));
		Q.Coeff(Q.Degre) := P_R.coeff(P_R.Degre) / P_R2.Coeff(P_R2.Degre);
		R := P_R - (Q * P_R2);
		return Q + (R / P_R2);
	end "/";

	function Reste(P : in T_Polynome; P2 : in T_Polynome) return T_Polynome is
	begin
		return P - ((P / P2) * P2);
	end Reste;

	function Eval(P : in T_Polynome; F : in T_Fraction) return T_Fraction is
		Result : T_Polynome;
	begin
		if P.Degre = 0 then
			return P.Coeff(0);
		end if;

		Result := (Degre => P.Degre - 1, Coeff => (others => (0, 1)));
		for I in Result.Coeff'Range loop
			Result.Coeff(I) := P.Coeff(I + 1);
		end loop;
		return P.Coeff(0) + (F * Eval(Result, F));
	end Eval;

	function Alloc_Polyn (N : T_Degre) return T_Polynome is
		Result : T_Polynome := (Degre => N, Coeff => (others => (0, 1)));
	begin
		Result.Coeff(N) := (1,1);
		return Result;
	end Alloc_Polyn;
	

end Gestion_Polynomes;