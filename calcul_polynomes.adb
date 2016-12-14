with gestion_polynomes; use gestion_polynomes;
with gestion_fractions; use gestion_fractions;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Characters.Handling; use Ada.Characters.Handling;

procedure Calcul_Polynomes is
	PARAMETRE_INCORRECT : exception;

	Function Est_Une_Operation(C : in Character) return Boolean is
	begin
		return C = '+' or C = '-' or C = 'x' or C = '/' or C = 'r' or C = 'e' or C = 'a';
	end Est_Une_Operation;

	P : T_Polynome;
	P2 : T_Polynome;
	F : T_Fraction;
	N : T_Degre;
	Operation : Character := ' ';
	Operation_Position : Natural := 0;
	I : Natural := 1; -- Incrémentation dans les Fractions
	J : Natural := 0; -- Coeffs
begin

	-- localisation de l'opération
	for I in 1 .. Argument_Count loop
      if Est_Une_Operation(Argument(I)(1)) then
      	if Operation = ' ' then
      		Operation := Argument(I)(1);
      		Operation_Position := I;
      	else -- deux opérations 
      		Put("Erreur : Veuillez n'entrer qu'une seule opération");
      		raise PARAMETRE_INCORRECT; 
      	end if;
      end if;
    end loop;

    P := (Degre => Operation_Position / 2 - 1, Coeff => (others => (0, 1)));
    while I < Operation_Position - 1 loop
    	P.Coeff(J) := (Integer'Value(Argument(I)), Integer'Value(Argument(I + 1)));
    	I := I + 2;
    	J := J + 1;
    end loop;

    if (Operation = '+' or Operation = '-' or Operation = 'x' or Operation = '/' or Operation = '/' or operation = 'r') then
    	P2 := (Degre => (Argument_Count - Operation_Position) / 2 - 1, Coeff => (others => (0, 1)));
    	I := Operation_Position + 1;
    	J := 0;
    	while I < Argument_Count loop
	    	P2.Coeff(J) := (Integer'Value(Argument(I)), Integer'Value(Argument(I + 1)));
	    	I := I + 2;
	    	J := J + 1;
	    end loop;
    elsif (Operation = 'e') then
    	F := (Integer'Value(Argument(Argument_Count - 1)), Integer'Value(Argument(Argument_Count)));
    else
    	N := Integer'Value(Argument(Argument_Count));
    end if;

    case Operation is
		when '+' => P := P + P2; -- addition de deux polynomes
		when '-' => P := P - P2; -- soustraction de deux polynomes
		when 'x' => P := P * P2; -- produit de deux polynomes
		when '/' => P := P / P2; -- division de deux polynomes
		when 'r' => P := Reste(P, P2); -- fraction à une puissance entière
		when 'e' => F := Eval(P, F); -- PGCD de deux entiers
		when 'a' => P := Alloc_Polyn(N);
		when others => 
			Put_Line("Opération invalide");
			raise PARAMETRE_INCORRECT;
	end case;

	if(Operation = 'e') then
		Put(F);
	else
		Put(P);
	end if;

	exception
		when others =>
			raise PARAMETRE_INCORRECT;
end Calcul_Polynomes;