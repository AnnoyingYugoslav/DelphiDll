library dll;



uses
  Classes, SysUtils;


//plik
// tekst - drugie okno dodawanie , tekstplik - tekst w pliku , password - haslo
var tekst, tekstplik, password : String;
//lista
type znaczniklisty1 = ^fragmentlisty1;
fragmentlisty1 = record
dane : String;
znacznik : znaczniklisty1;
end;
var i, k, m : Integer; // i - licznik fragnebtów, k - test czy zapisane, m - dlugosc listy
var element : String;
var fragment_aktualny, fragment_next, fragment_past, fragment_first, przesuwanie_aktualny, przesuwanie_past : znaczniklisty1;
procedure nast(var obiekt : string; var koniec : Boolean);stdcall;
begin
  if przesuwanie_aktualny <> nil then
  if przesuwanie_aktualny^.znacznik <> nil then begin
  przesuwanie_past := przesuwanie_aktualny;
  przesuwanie_aktualny := przesuwanie_aktualny^.znacznik;
  obiekt := przesuwanie_aktualny^.dane;
  fragment_aktualny := przesuwanie_aktualny;
  fragment_past := przesuwanie_past;
  fragment_next := fragment_aktualny^.znacznik;
  end
  else begin
  koniec := True;
end;

end;
procedure restart(var obiekt : string);stdcall;
begin
  if przesuwanie_aktualny <> nil then begin
przesuwanie_aktualny := fragment_first;
przesuwanie_past := nil;
fragment_aktualny := przesuwanie_aktualny;
fragment_past := przesuwanie_past;
fragment_next := fragment_aktualny^.znacznik;
obiekt := przesuwanie_aktualny^.dane;
end;

end;

procedure dodaj(var obiekt : string; var counter : Integer);stdcall;
begin
if fragment_aktualny <> nil then begin
fragment_past:= fragment_aktualny;
fragment_next:= fragment_aktualny^.znacznik;
end
else begin
fragment_past := nil;
fragment_next := nil;
end;
New(fragment_aktualny);
with fragment_aktualny^ do
begin
dane:= obiekt;
znacznik:= fragment_next;
end;
if fragment_past <> nil then begin
fragment_past^.znacznik := fragment_aktualny;
end;
if counter = 0 then begin
fragment_first:= fragment_aktualny;
obiekt := Fragment_first^.dane;
przesuwanie_aktualny := fragment_first;
end;
counter := counter + 1;
end;

procedure delete(var obiekt : string; var counter : Integer);stdcall;
begin
   if przesuwanie_aktualny <> nil then

begin
  //usuwanie obiektu
fragment_aktualny := przesuwanie_aktualny;
fragment_past := przesuwanie_past;
fragment_next := fragment_aktualny^.znacznik;
if (fragment_first <> nil) and (fragment_aktualny <> nil) then
if fragment_first <> fragment_aktualny then
begin
counter := counter - 1;
fragment_past := fragment_first;
fragment_next:=fragment_past^.znacznik;
if fragment_next <> fragment_aktualny then repeat
  fragment_past:=fragment_next;
  fragment_next := fragment_past^.znacznik
  until fragment_next = fragment_aktualny;
with fragment_aktualny^ do
begin
element:= obiekt;
fragment_past^.znacznik := znacznik;
end;
Dispose(fragment_aktualny);
fragment_aktualny:= fragment_past;
end
else begin
counter := counter - 1;
with fragment_first^ do
begin
element:=dane;
fragment_first := znacznik;
end;
Dispose(fragment_aktualny);
fragment_aktualny:=fragment_first;
end;
przesuwanie_aktualny := fragment_aktualny;
if  przesuwanie_aktualny <> nil then begin
obiekt := przesuwanie_aktualny^.dane;
fragment_aktualny := przesuwanie_aktualny;
fragment_past := przesuwanie_past;
fragment_next := fragment_aktualny^.znacznik;
end
else begin
obiekt := '';
end;

end;

end;
procedure zapisz1(var obiekt : string);stdcall;
begin
obiekt := fragment_first^.dane;
fragment_aktualny := fragment_first;
end;
procedure zapisz2(var obiekt : string);stdcall;
begin
if fragment_aktualny <> nil then begin
fragment_aktualny := fragment_aktualny^.znacznik;
obiekt := fragment_aktualny^.dane;
end;
end;
procedure clean();stdcall;
begin
fragment_first := nil; //czyszczenie
fragment_next := nil;
fragment_past := nil;
fragment_aktualny := nil;
przesuwanie_aktualny := nil;
przesuwanie_past := nil;
end;
exports
nast,
restart,
dodaj,
delete,
zapisz1,
zapisz2,
clean;
begin
end.


