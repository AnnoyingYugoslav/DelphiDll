unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;
procedure restart(var obiekt : string);stdcall; external 'project1.dll';
procedure dodaj(var obiekt : string; var counter : Integer);stdcall; external 'project1.dll';
procedure delete(var obiekt : string; var counter : Integer);stdcall; external 'project1.dll';
procedure zapisz1(var obiekt : string);stdcall; external 'project1.dll';
procedure zapisz2(var obiekt : string);stdcall; external 'project1.dll';
procedure nast(var obiekt : string; var koniec : Boolean);stdcall; external 'project1.dll';
procedure clean();stdcall; external 'project1.dll';
type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure start(Sender: TObject);
    procedure stopit(Sender: TObject; var CanClos: Boolean);

  private

  public

  var dane, password, tekstplik : String;
  var CanClose, koniec : Boolean;
  var licznik, m : Integer;
  var save : TStringList;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button4Click(Sender: TObject);
begin//add
try
 begin
  dane := Edit3.Text;
  Edit3.Clear;
  dodaj(dane, licznik);
  Edit2.Text := inttostr(licznik);
  if licznik = 1 then begin
  Edit1.Text := dane;
  end;
  koniec := False;
  CanClose := False;
  end
except
  ShowMessage('Error');
end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin //import
try
  if CanClose = False then begin
  if Dialogs.MessageDlg('Jestes pewien, ze chcesz otworzyc bez zapisania otwartej listy?',
      mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then begin
      if OpenDialog1.Execute then
      if FileExists(OpenDialog1.FileName) then begin
         save := TStringList.Create();
         save.LoadFromFile(OpenDialog1.FileName);
         m := save.count - 1;
         if save[m] = password then begin
            save.Delete(m);
            clean();
            Edit1.Clear;
            licznik := 0;
            for tekstplik in save do begin
             dodaj(tekstplik, licznik);
            end;
            Edit2.Text := inttostr(licznik);
            save.Destroy();
         end
         else begin ShowMessage('Zly plik'); end;
      end;

      end;
end
  else begin //drugie
        if OpenDialog1.Execute then
      if FileExists(OpenDialog1.FileName) then begin
         save := TStringList.Create();
         save.LoadFromFile(OpenDialog1.FileName);
         m := save.count - 1;
         if save[m] = password then begin
            save.Delete(m);
            clean();
            Edit1.Clear;
            licznik := 0;
            for tekstplik in save do begin
             dodaj(tekstplik, licznik);
            end;
            Edit2.Text := inttostr(licznik);
            save.free();
         end
         else begin ShowMessage('Zly plik'); end;
      end;
  end;

except
  ShowMessage('blad');
end;

end;

procedure TForm1.Button6Click(Sender: TObject);
var liczenie : Integer;
begin
//export
try begin
save := TStringList.Create();
zapisz1(dane);
save.Add(dane);
for liczenie := 2 to licznik do
begin
zapisz2(dane);
save.Add(dane);
end;
save.Add(password);
if SaveDialog1.Execute then
if FileExists(SaveDialog1.FileName) then begin
ShowMessage('Plik już istnieje.')
end
else
save.SaveToFile(SaveDialog1.FileName);
CanClose := True;
end;
save.Free;
except
ShowMessage('Error Export');
end;

end;

procedure TForm1.start(Sender: TObject);
begin
OpenDialog1.Filter := 'Text files (*.txt)|*.TXT';
SaveDialog1.Filter := 'Text files (*.txt)|*.TXT|Any file (*.*)|*.*';
password := 'haslomaslotrzaslo';
CanClose := True;
end;

procedure TForm1.stopit(Sender: TObject; var CanClos: Boolean);
begin
  if CanClose = False then begin
  if Dialogs.MessageDlg('Jestes pewien, ze chcesz otworzyc bez zapisania otwartej listy?',
      mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrNo then begin
      CanClos := False;
      end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin//next
try
 begin
nast(dane, koniec);
Edit1.Text := dane;
if koniec = True then begin
   ShowMessage('Koniec');

end;
end

except
  ShowMessage('Error');
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin//restart
 try
 restart(dane);
 Edit1.Text := dane;
 koniec := False;
except
  ShowMessage('Error');
end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin//delete
 try
  delete(dane, licznik);
  Edit2.Text := inttostr(licznik);
  Edit1.Text := dane;
  CanClose := False;
except
  ShowMessage('Error');
end;
end;

end.

