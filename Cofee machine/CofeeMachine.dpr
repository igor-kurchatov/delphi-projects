program CofeeMachine;

uses
  Forms,
  uBaseForm in 'uBaseForm.pas' {Form1},
  uGenerics in 'Source\uGenerics.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
