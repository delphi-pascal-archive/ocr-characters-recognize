unit OCRUtils;

interface

uses Graphics;

type
  TModel = array [1..100, 1..100] of Boolean;
  { Chaque élément du tableau représente un pixel - True si noir, False si blanc }

function CreateModel(Model: Char): TModel; overload
{ Crée un modèle à partir d'un caractère }

function CreateModel(Model: TBitmap): TModel; overload
{ Crée un modèle à partir d'un bitmap }

function CompareModels(A, B: TModel): Integer;
{ Compare deux modèles et indique le nombre de valeurs différentes }

implementation

function CreateModel(Model: Char): TModel; { Crée un modèle depuis un caractère }
Var
 Bmp: TBitmap;
 I, J: Integer;
 W, H: Integer;
begin
 { On écrit avec une police dans un bitmap et on regarde les couleurs des pixels }
 Bmp := TBitmap.Create;
 Bmp.Width := 100;
 Bmp.Height := 100;
 Bmp.PixelFormat := pf1Bit;
 Bmp.Canvas.Font.Name := 'Arial';
 Bmp.Canvas.Font.Size := 72; { On crée le bitmap tampon ... on initialise ... }
 W := Bmp.Canvas.TextWidth(Model);
 H := Bmp.Canvas.TextHeight(Model);
 Bmp.Canvas.TextOut(50 - (W div 2), 50 - (H div 2), Model); { On écrit le caractère au centre ... }
 for I := 0 to 99 do
  for J := 0 to 99 do { Si bitmap blanc, modèle False, sinon, modèle True }
   if Bmp.Canvas.Pixels[I, J] = clWhite then Result[I + 1, J + 1] := False else Result[I + 1, J + 1] := True;

 Bmp.Free;
end;

function CreateModel(Model: TBitmap): TModel; overload { Crée un modèle depuis un bitmap }
Var
 I, J: Integer;
begin
 Model.Width := 100;
 Model.Height := 100;
 Model.PixelFormat := pf1Bit;
 for I := 0 to 99 do
  for J := 0 to 99 do { Si le bitmap est blanc, modèle False, sinon, modèle True }
   if Model.Canvas.Pixels[I, J] = clWhite then Result[I + 1, J + 1] := False else Result[I + 1, J + 1] := True;
end;

function CompareModels(A, B: TModel): Integer;
Var
 I, J: Integer;
begin
 Result := 0;
 for I := 1 to 100 do
  for J := 1 to 100 do
   begin
    { Si le modèle dessiné n'a pas une zone du modèle enregistré, on enlève 100 points }
    if (A[I, J] = False) and (B[I, J] = True) then Dec(Result, 100);
    { Si le modèle enregistré n'a pas une zone du modèle dessiné, on enlève 15 points }
    if (A[I, J] = True) and (B[I, J] = False) then Dec(Result, 15);
    { Si les deux modèles ont la même zone coloriée en noir, on ajoute 100 points }
    if (A[I, J] = True) and (B[I, J] = True) then Inc(Result, 100);
   end;

 { On limite à 0 (pas d'intérêt fonctionnel mais ça fait plus joli) }
 if Result < 0 then Result := 0;

 { Cet équilibre de points permet de désigner avec la plus grande précision le caractère
   que l'on a écrit. }
end;

end.