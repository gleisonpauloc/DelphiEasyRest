# DelphiEasyRest
Easy to use library to build simple REST Server using Indy library.

Works on Linux (Delphi 10.2 Tokyo or better).

## Sample

```Pascal
  ...
var
 EasyServer: TDERestServer;
  ...

begin
  EasyServer := TDERestServer.Create(nil);
  EasyServer.Port := 80;

  EasyServer.AddMethod('/sum/{num1}/{num2}', hmGet, TCalc.Sum);
  EasyServer.AddMethod('/sub/{num1}/{num2}', hmGet, TCalc.Sub);
  EasyServer.AddMethod('/mult/{num1}/{num2}', hmGet, TCalc.Mult);
  EasyServer.AddMethod('/divi/{num1}/{num2}', hmGet, TCalc.Divi);

  EasyServer.Active := True;
end
```


```Pascal
class procedure TCalc.Sum(ARequest: TDERRequest; AResponse: TDERResponse);
var
  Num1, Num2: Double;
begin
  Num1 := ARequest.Params.Items['num1'].ToDouble;
  Num2 := ARequest.Params.Items['num2'].ToDouble;

  AResponse.Header.SetStatus(uHTTPStatus.StatusOK);

  AResponse.ContentJSONFromObject(TCalcResult.New(Num1 + Num2) as TCalcResult);
end;
```