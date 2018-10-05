unit uDERServer;

interface

uses
  IdHttpServer, IdContext, IdCustomHTTPServer, uDERResources,
  System.Classes, System.Generics.Collections, uDERRequest;

type

  TDERestServer = class(TComponent)
  private
    FHTTPServer: TIdHttpServer;
    FResourceList: TDERResourceClassDictionary;
    FResourceMapList: TDERResourceMapDictionary;

    function GetActive: Boolean;
    procedure SetActive(const Value: Boolean);

    procedure DoCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    function GetPort: Integer;
    procedure SetPort(const Value: Integer);
    function ResourceMatch(AResourceMap: TResourceMap; const ADocumentRequest: string; AParameters: TRequestParams): boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddResource(AResource: string; AResourceClass: TDERResourceClass);
    procedure AddMethod(AResource: string; AHTTPMethod: THttpMethod; AMethod: TDERHTTPMethod);
  published
    property Port: Integer read GetPort write SetPort;
    property Active: Boolean read GetActive write SetActive;
  end;


implementation

uses
  System.SysUtils, System.RegularExpressions, uDERResponse, IdURI, IdGlobal,
  System.Diagnostics, System.StrUtils, System.Types, uHTTPStatus;

{ TDERServer }

procedure TDERestServer.AddMethod(AResource: string; AHTTPMethod: THttpMethod;
  AMethod: TDERHTTPMethod);
var
  ResourceMap: TResourceMap;
begin
  ResourceMap := TResourceMap.Create();
  try
    ResourceMap.Resource := AResource;
    ResourceMap.HTTPMethod := AHTTPMethod;
    ResourceMap.Method := AMethod;

    FResourceMapList.Add(AResource, ResourceMap);
  except
    FreeAndNil(ResourceMap);
    raise;
  end;
end;

procedure TDERestServer.AddResource(AResource: string;
  AResourceClass: TDERResourceClass);
begin
  FResourceList.Add(AResource, AResourceClass);
end;

constructor TDERestServer.Create(AOwner: TComponent);
begin
  inherited;

  FHTTPServer := TIdHTTPServer.Create(nil);
  FHTTPServer.OnCommandGet := DoCommandGet;
  FResourceList := TDERResourceClassDictionary.Create;
  FResourceMapList := TDERResourceMapDictionary.Create([doOwnsValues]);
end;

destructor TDERestServer.Destroy;
begin
  FreeAndNil(FHTTPServer);
  FreeAndNil(FResourceList);
  FreeAndNil(FResourceMapList);
  inherited;
end;

procedure TDERestServer.DoCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  ResourceElem: TDERResourceMapElem;
  HttpMethod: THttpMethod;

  ARequest: TDERRequest;
  AResponse: TDERResponse;
begin
  HttpMethod := StringToHttpMethod(ARequestInfo.Command);

  AResponse := nil;
  ARequest := TDERRequest.Create;
  try
    AResponse := TDERResponse.Create;
    AResponse.Header.SetStatus(uHTTPStatus.StatusBadRequest);

    ARequest.IndyRequest := ARequestInfo;

    for ResourceElem in FResourceMapList do
    begin
      if (ResourceElem.Value.HTTPMethod = HttpMethod) and
         (ResourceMatch(ResourceElem.Value, ARequestInfo.URI, ARequest.Params)) then
      begin
        ResourceElem.Value.Method(ARequest, AResponse);
        break;
      end;
    end;

    AResponse.FillIndyResponse(AResponseInfo);
  finally
    FreeAndNil(AResponse);
    FreeAndNil(ARequest);
  end;
end;

function TDERestServer.GetActive: Boolean;
begin
  Result := FHTTPServer.Active;
end;

function TDERestServer.GetPort: Integer;
begin
  Result := FHTTPServer.DefaultPort;
end;

function TDERestServer.ResourceMatch(AResourceMap: TResourceMap; const
  ADocumentRequest: string; AParameters: TRequestParams): boolean;

  function IsParameter(const AValue: string; out AParameter: string): Boolean;
  begin
    Result := (AValue.Length > 2) and (AValue.Chars[0] = '{') and (AValue.Chars[AValue.Length - 1] = '}');
    if Result then
      AParameter := Copy(AValue, 2, AValue.Length - 2);
  end;

  function DecodeURI(const AURI: string): string;
  begin
    Result := TIdURI.URLDecode( ReplaceAll(AURI, '+', ' '), IndyTextEncoding(encUTF8));
  end;

  procedure DecodeURIRequest(var ArrayURI: TStringDynArray);
  var
    I: Integer;
  begin
    for I := 0 to Pred(Length(ArrayURI)) do
      ArrayURI[I] := DecodeURI(ArrayURI[I]);
  end;

var
  ArrayRequest: TStringDynArray;
  ResourceCount, I: Integer;
  Parameter: string;

begin
  Result := False;

  ArrayRequest := SplitString(ADocumentRequest, '/');
  DecodeURIRequest(ArrayRequest);
  try
    ResourceCount := Length(AResourceMap.ResourceSplit);
    if ResourceCount = Length(ArrayRequest) then
    begin
      for I := 0 to Pred(ResourceCount) do
      begin
        if AResourceMap.ResourceSplit[I] <> ArrayRequest[I] then
        begin
          if IsParameter(AResourceMap.ResourceSplit[I], Parameter) then
            AParameters.Add(Parameter, ArrayRequest[I])
          else
            Exit(False);
        end;
      end;
    end;

    Result := True;

  finally
    if not Result then
      AParameters.Clear;
  end;

end;

procedure TDERestServer.SetActive(const Value: Boolean);
begin
  FHTTPServer.Active := Value;
end;

procedure TDERestServer.SetPort(const Value: Integer);
begin
  FHTTPServer.DefaultPort := Value;
end;

end.
