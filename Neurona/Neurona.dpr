program Neurona;

uses
  Forms,
  ClientNeurona in '..\ClientNeurona.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Name := 'Neurona';
  Application.Title := 'Neurona';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
