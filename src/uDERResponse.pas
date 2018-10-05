unit uDERResponse;

interface

uses
  REST.Json, IdCustomHTTPServer;

type

  TDERHeader = class
  private
    FContentType: string;
    FResponseCode: Integer;
    FResponseText: string;
  public
    property ContentType: string read FContentType write FContentType;
    property ResponseText: string read FResponseText write FResponseText;
    property ResponseCode: Integer read FResponseCode write FResponseCode;

    procedure SetStatus(const AStatusCode: Integer);
  end;

  TDERResponse = class
  private
    FHeader: TDERHeader;
    FContentText: string;
  public
    constructor Create;
    destructor Destroy; override;
    property Header: TDERHeader read FHeader;
    property ContentText: string read FContentText write FContentText;

    procedure ContentJSONFromObject(AObject: TObject; AOptions: TJsonOptions = [joDateIsUTC, joDateFormatISO8601]);
    procedure SetContentJsonText(const AJSONText: string);
    procedure SetContentPlainText(const APlainText: string);

    procedure FillIndyResponse(ResponseInfo: TIdHTTPResponseInfo);
  end;



implementation

uses
  System.SysUtils, uHTTPStatus;

{ TDERResponse }

constructor TDERResponse.Create;
begin
  FHeader := TDERHeader.Create;
  FHeader.SetStatus(uHTTPStatus.StatusOK);
end;

destructor TDERResponse.Destroy;
begin
  FreeAndNil(FHeader);
  inherited;
end;

procedure TDERResponse.FillIndyResponse(ResponseInfo: TIdHTTPResponseInfo);
begin
  ResponseInfo.ResponseText := FHeader.ResponseText;
  ResponseInfo.ResponseNo := FHeader.ResponseCode;
  ResponseInfo.ContentText := FContentText;
  ResponseInfo.ContentType := FHeader.ContentType;
end;

procedure TDERResponse.ContentJSONFromObject(AObject: TObject;
  AOptions: TJsonOptions);
begin
  SetContentJsonText(TJson.ObjectToJsonString(AObject, AOptions));
end;


procedure TDERResponse.SetContentJsonText(const AJSONText: string);
begin
  FContentText := AJSONText;
  FHeader.ContentType := 'application/json';
end;

procedure TDERResponse.SetContentPlainText(const APlainText: string);
begin
  FContentText := APlainText;
  FHeader.ContentType := 'text/plain';
end;

{ TDERHeader }

procedure TDERHeader.SetStatus(const AStatusCode: Integer);
begin
  FResponseText := uHTTPStatus.StatusText(AStatusCode);
  FResponseCode := AStatusCode;
end;

end.
