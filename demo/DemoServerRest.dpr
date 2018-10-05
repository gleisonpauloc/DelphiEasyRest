program DemoServerRest;

uses
  Vcl.Forms,
  UnMainSrvRest in 'UnMainSrvRest.pas' {Form1},
  uDERServer in '..\src\uDERServer.pas',
  uDERResources in '..\src\uDERResources.pas',
  uDERResponse in '..\src\uDERResponse.pas',
  uDERRequest in '..\src\uDERRequest.pas',
  uHTTPStatus in '..\src\uHTTPStatus.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
