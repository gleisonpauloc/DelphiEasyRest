(*
 * DelphiEasyRest
 * Copyright (c) 2019 Gleison Paulo Caldeira Oliveira
 * This file is a part of DelphiEasyRest.
 * https://github.com/gleisonpauloc/DelphiEasyRest
 * This project is licensed under the terms of the MIT license.
*)
unit uDERResources;

interface

uses
  IdContext, IdCustomHTTPServer, System.Generics.Collections, REST.Json,
  uDERResponse, uDERRequest, System.Types;

type
  TDERResource = class;
  TDERContext = class;
  TDERArgs = array of string;
  TDERResourceClass = class of TDERResource;
  TDERResourceClassDictionary = TDictionary<string, TDERResourceClass>;

  TDERResourceClassElem = TPair<string, TDERResourceClass>;
  TDERHTTPMethod = procedure (ARequest: TDERRequest; AResponse: TDERResponse) of object;
  THttpMethod = (hmPost, hmGet, hmPut, hmDelete, hmPatch);

  TResourceMap = class
  private
    FMethod: TDERHTTPMethod;
    FResource: string;
    FHTTPMethod: THttpMethod;
    FResourceSplit: TStringDynArray;
    procedure SetResource(const Value: string);
  public
    property ResourceSplit: TStringDynArray read FResourceSplit;
    property Resource: string read FResource write SetResource;
    property HTTPMethod: THttpMethod read FHTTPMethod write FHTTPMethod;
    property Method: TDERHTTPMethod read FMethod write FMethod;
  end;
  TDERResourceMapDictionary = TObjectDictionary<string, TResourceMap>;
  TDERResourceMapElem = TPair<string, TResourceMap>;

  TDERContext = class
  private
    FIdContext: TIdContext;
    FIdRequestInfo: TIdHTTPRequestInfo;
    FIdResponseInfo: TIdHTTPResponseInfo;
  public
    property IdContext: TIdContext read FIdContext write FIdContext;
    property IdRequestInfo: TIdHTTPRequestInfo read FIdRequestInfo
      write FIdRequestInfo;
    property IdResponseInfo: TIdHTTPResponseInfo read FIdResponseInfo
      write FIdResponseInfo;
  end;


  TDERResource = class
  public
    procedure Request(AMethod: THttpMethod; ARequest: TDERRequest; AResponse: TDERResponse);

    procedure Post(ARequest: TDERRequest; AResponse: TDERResponse); virtual;
    procedure Get(ARequest: TDERRequest; AResponse: TDERResponse); virtual;
    procedure Put(ARequest: TDERRequest; AResponse: TDERResponse); virtual;
    procedure Delete(ARequest: TDERRequest; AResponse: TDERResponse); virtual;
    procedure Patch(ARequest: TDERRequest; AResponse: TDERResponse); virtual;
  end;

  function StringToHttpMethod(const AValue: string): THttpMethod;

implementation

uses
  System.SysUtils, System.StrUtils;

function StringToHttpMethod(const AValue: string): THttpMethod;
begin

  if SameText(AValue, 'get') then
    Result := hmGet

  else if SameText(AValue, 'Post') then
    Result := hmPost

  else if SameText(AValue, 'Put') then
    Result := hmPut

  else if SameText(AValue, 'Delete') then
    Result := hmDelete

  else if SameText(AValue, 'Patch') then
    Result := hmPatch

  else
    raise Exception.Create('Unrecognized http method.');
end;


{ TDERResource }

procedure TDERResource.Delete(ARequest: TDERRequest; AResponse: TDERResponse);
begin

end;

procedure TDERResource.Get(ARequest: TDERRequest; AResponse: TDERResponse);
begin

end;

procedure TDERResource.Patch(ARequest: TDERRequest; AResponse: TDERResponse);
begin

end;

procedure TDERResource.Post(ARequest: TDERRequest; AResponse: TDERResponse);
begin

end;

procedure TDERResource.Put(ARequest: TDERRequest; AResponse: TDERResponse);
begin

end;

procedure TDERResource.Request(AMethod: THttpMethod;
  ARequest: TDERRequest; AResponse: TDERResponse);
begin
  case AMethod of
    hmPost: Post(ARequest, AResponse);
    hmGet: Get(ARequest, AResponse);
    hmPut: Put(ARequest, AResponse);
    hmDelete: Delete(ARequest, AResponse);
    hmPatch: Patch(ARequest, AResponse);
  end;
end;

{ TResourceMap }

procedure TResourceMap.SetResource(const Value: string);
begin
  FResource := Value;
  FResourceSplit := SplitString(Value, '/');
end;

end.
