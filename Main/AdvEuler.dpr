program AdvEuler;

uses
  Forms,
  InfiMainForm in 'InfiMainForm.pas' {Form1},
  InfiServer in 'InfiServer.pas' {Form2},
  Parameters in 'Parameters.pas' {Form3},
  FacThread in 'FacThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Calc^e';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
