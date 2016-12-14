with gestion_fractions; use gestion_fractions;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Characters.Handling; use Ada.Characters.Handling;

procedure Calcul_Fractions is
	PARAMETRE_INCORRECT : exception;

	Function Est_Une_Operation(C : in Character) return Boolean is
	begin
		return C = '+' or C = '-' or C = 'x' or C = '/' or C = 'p' or C = 'P';
	end Est_Une_Operation;

	F : T_Fraction;
	F2 : T_Fraction;
	Int : Integer;
	Int2 : Integer;
	Operation : Character := ' ';
	Operation_Position : Natural := 0;

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

    -- nombre d'arguments invalide
	if not (Argument_Count in 3 .. 5) then
		Put("Erreur : Veuillez entrer entre 3 et 5 arguments");
		raise PARAMETRE_INCORRECT;
	end if;

	case Argument_Count is
		when 5 => -- 1 2 X 4 5
			if Est_Une_Operation(Argument(3)(1)) then
				F := (Integer'Value(Argument(1)), Integer'Value(Argument(2)));
				F2 := (Integer'Value(Argument(4)), Integer'Value(Argument(5)));
			end if;

		when 4 =>
			if Operation_Position = 2 then -- 1 X 3 4
				F := (Integer'Value(Argument(1)), 1);
				F2 := (Integer'Value(Argument(3)), Integer'Value(Argument(4)));

			elsif Operation_Position = 3 then -- 1 2 X 4
				F := (Integer'Value(Argument(1)), Integer'Value(Argument(2)));
				if Operation = 'p' then
					Int := Integer'Value(Argument(4));
				else
					F2 := (Integer'Value(Argument(4)), 1);
				end if;
			end if;

		when 3 =>
			if Argument(3) = "PGCD" then -- 1 2 PGCD
				Int := Integer'Value(Argument(1));
				Int2 := Integer'Value(Argument(2));

			elsif Operation_Position = 2 then -- 1 X 3
					F := (Integer'Value(Argument(1)), 1);
				if Operation = 'p' then
					Int := Integer'Value(Argument(3));
				else
					F2 := (Integer'Value(Argument(3)), 1);
				end if;
			end if;

		when others => -- not 3/4/5
			Put_Line("Veuillez entrer le bon nombre de paramètres ! (3|4|5)");
			raise PARAMETRE_INCORRECT;
			
	end case;

	if not (Operation = 'P') and (F. Den = 0 or (not (Operation = 'p') and F2.Den = 0)) then
		Put_Line("Le dénominateur ne peut être nul !");
		raise DIV_PAR_ZERO;
	end if;
	if Operation = 'P' then
		if Int = 0 or Int2 = 0 then
			Put_Line("Les nombres doivent être positifs pour le PGCD !");
			raise PARAMETRE_INCORRECT;
		end if;
	end if;

	case Operation is
		when '+' => F := F + F2; -- addition de deux fractions
		when '-' => F := F - F2; -- soustraction de deux fractions
		when 'x' => F := F * F2; -- produit de deux fractions
		when '/' => F := F / F2; -- division de deux fractions
		when 'p' => F := F ** Int; -- fraction à une puissance entière
		when 'P' => Int := PGCD(Int, Int2); -- PGCD de deux entiers
		when others => 
			Put_Line("Opération invalide");
			raise PARAMETRE_INCORRECT;
	end case;

	if not Est_Une_Operation(Operation) then
		Put_Line("Paramètre incorrect détecté. (+|-|*|/|p|PGCD)");
		raise PARAMETRE_INCORRECT;
	end if;
	
	if Operation = 'P' then
		put(Integer'Image(Int));
	else
		put(F);
	end if;


end Calcul_Fractions;