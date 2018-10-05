unit UnMainSrvRest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uDERServer,
  uDERResources, uDERRequest, uDERResponse;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FEasyServer:  TDERestServer;
  public
    { Public declarations }
  end;

  TCalc = class
    class procedure Sum(ARequest: TDERRequest; AResponse: TDERResponse);
    class procedure Sub(ARequest: TDERRequest; AResponse: TDERResponse);
    class procedure Mult(ARequest: TDERRequest; AResponse: TDERResponse);
    class procedure Divi(ARequest: TDERRequest; AResponse: TDERResponse);
  end;

  ICalcResult = Interface
    procedure SetResult(const AValue: Double);
    function GetResult: Double;

    property Result: Double read GetResult write SetResult;
  end;

  TCalcResult = class(TInterfacedObject, ICalcResult)
  private
    FResult: Double;
    function GetResult: Double;
    procedure SetResult(const Value: Double);
  public
    class function New(const Value: Double): ICalcResult;
    property Result: Double read GetResult write SetResult;
  end;


var
  Form1: TForm1;


implementation

uses
  uHTTPStatus;

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FEasyServer := TDERestServer.Create(nil);
  FEasyServer.Port := 80;

  FEasyServer.AddMethod('/sum/{num1}/{num2}', hmGet, TCalc.Sum);
  FEasyServer.AddMethod('/sub/{num1}/{num2}', hmGet, TCalc.Sub);
  FEasyServer.AddMethod('/mult/{num1}/{num2}', hmGet, TCalc.Mult);
  FEasyServer.AddMethod('/divi/{num1}/{num2}', hmGet, TCalc.Divi);

  FEasyServer.Active := True;

  Memo1.Lines.Add('Sample:');
  Memo1.Lines.Add('http://localhost:80/sum/5/5');
  Memo1.Lines.Add('http://localhost:80/sub/5/5');
  Memo1.Lines.Add('http://localhost:80/mult/5/5');
  Memo1.Lines.Add('http://localhost:80/divi/5/5');

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEasyServer);
end;

{ TCalcResult }

function TCalcResult.GetResult: Double;
begin
  Result := FResult;
end;

class function TCalcResult.New(const Value: Double): ICalcResult;
begin
  Result := TCalcResult.Create;
  Result.Result := Value;
end;

procedure TCalcResult.SetResult(const Value: Double);
begin
  FResult := Value;
end;


{ TCalc }

class procedure TCalc.Divi(ARequest: TDERRequest;
  AResponse: TDERResponse);
var
  Num1, Num2: Double;
begin
  Num1 := ARequest.Params.Items['num1'].ToDouble;
  Num2 := ARequest.Params.Items['num2'].ToDouble;

  AResponse.Header.SetStatus(uHTTPStatus.StatusOK);

  AResponse.ContentJSONFromObject(TCalcResult.New(Num1 / Num2) as TCalcResult);
end;

class procedure TCalc.Mult(ARequest: TDERRequest;
  AResponse: TDERResponse);
var
  Num1, Num2: Double;
begin
  Num1 := ARequest.Params.Items['num1'].ToDouble;
  Num2 := ARequest.Params.Items['num2'].ToDouble;

  AResponse.Header.SetStatus(uHTTPStatus.StatusOK);
  AResponse.ContentJSONFromObject(TCalcResult.New(Num1 * Num2) as TCalcResult);
end;

class procedure TCalc.Sub(ARequest: TDERRequest;
  AResponse: TDERResponse);
var
  Num1, Num2: Double;
begin
  Num1 := ARequest.Params.Items['num1'].ToDouble;
  Num2 := ARequest.Params.Items['num2'].ToDouble;

  AResponse.Header.SetStatus(uHTTPStatus.StatusOK);
  AResponse.ContentJSONFromObject(TCalcResult.New(Num1 - Num2) as TCalcResult);
end;

class procedure TCalc.Sum(ARequest: TDERRequest;
  AResponse: TDERResponse);
var
  Num1, Num2: Double;
begin
  Num1 := ARequest.Params.Items['num1'].ToDouble;
  Num2 := ARequest.Params.Items['num2'].ToDouble;

  AResponse.Header.SetStatus(uHTTPStatus.StatusOK);
  AResponse.ContentJSONFromObject(TCalcResult.New(Num1 + Num2) as TCalcResult);
end;


end.
