unit uDERRequest;

interface

uses
  IdCustomHTTPServer, System.Generics.Collections;
type

  TRequestParams = TDictionary<string, string>;

  TDERRequest = class
  private
    FParams: TRequestParams;
    FIndyRequest: TIdHTTPRequestInfo;
  public
    constructor Create;
    destructor Destroy; override;
    property IndyRequest: TIdHTTPRequestInfo read FIndyRequest write FIndyRequest;
    property Params: TRequestParams read FParams;
  end;

implementation

uses
  System.SysUtils;

{ TEasyRestRequest }

constructor TDERRequest.Create;
begin
  FParams := TRequestParams.Create();
end;

destructor TDERRequest.Destroy;
begin
  FreeAndNil(FParams);
  inherited;
end;

end.
