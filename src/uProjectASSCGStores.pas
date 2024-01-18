unit uProjectASSCGStores;

{
  Stores DB for App Stores Screen Captures Generator :

  Magasin / OS => libelle
  Appareil(s) => libelle, JPG ou PNG, obligatoire ou pas
  taille(s) => largeur x hauteur en pixels
}
interface

uses
  System.JSON,
  System.Generics.Collections,
  System.SysUtils;

{$SCOPEDENUMS ON}

const
{$IFDEF DEBUG}
  CASSCGDBURL = 'http://localhost/asscgdb/storesdb.json';
{$ELSE}
  CASSCGDBURL =
    'https://appstoresscreencapturesgenerator.olfsoftware.fr/storesdb.json';
{$ENDIF}

type
  TASSCGDBImageType = (JPG, PNG);

  TASSCGDBImageSize = class
  private
    FEnabled: boolean;
    FWidth: integer;
    FHeight: integer;
    function GetAsJSON: TJSONObject;
    procedure SetAsJSON(const Value: TJSONObject);
    procedure SetEnabled(const Value: boolean);
    procedure SetHeight(const Value: integer);
    procedure SetWidth(const Value: integer);
  protected
  public
    property Width: integer read FWidth write SetWidth;
    property Height: integer read FHeight write SetHeight;
    property Enabled: boolean read FEnabled write SetEnabled;
    property AsJSON: TJSONObject read GetAsJSON write SetAsJSON;
    constructor Create(AJSON: TJSONObject); overload;
    constructor Create; overload;
  end;

  TASSCGDBImageSizes = class(TObjectList<TASSCGDBImageSize>)
  private
    function GetAsJSON: TJSONArray;
    procedure SetAsJSON(const Value: TJSONArray);
  protected
  public
    property AsJSON: TJSONArray read GetAsJSON write SetAsJSON;
  end;

  TASSCGDBDevice = class
  private
    FisNeeded: boolean;
    FName: string;
    FEnabled: boolean;
    FImageType: TASSCGDBImageType;
    FImageSizes: TASSCGDBImageSizes;
    function GetAsJSON: TJSONObject;
    procedure SetAsJSON(const Value: TJSONObject);
    procedure SetEnabled(const Value: boolean);
    procedure SetImageSizes(const Value: TASSCGDBImageSizes);
    procedure SetImageType(const Value: TASSCGDBImageType);
    procedure SetisNeeded(const Value: boolean);
    procedure SetName(const Value: string);
  protected
  public
    property Name: string read FName write SetName;
    property ImageType: TASSCGDBImageType read FImageType write SetImageType;
    property isNeeded: boolean read FisNeeded write SetisNeeded;
    property ImageSizes: TASSCGDBImageSizes read FImageSizes
      write SetImageSizes;
    property Enabled: boolean read FEnabled write SetEnabled;
    property AsJSON: TJSONObject read GetAsJSON write SetAsJSON;
    constructor Create(AJSON: TJSONObject); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;

  TASSCGDBDevices = class(TObjectList<TASSCGDBDevice>)
  private
    function GetAsJSON: TJSONArray;
    procedure SetAsJSON(const Value: TJSONArray);
  protected
  public
    property AsJSON: TJSONArray read GetAsJSON write SetAsJSON;
  end;

  TASSCGDBStore = class
  private
    FName: string;
    FEnabled: boolean;
    FDevices: TASSCGDBDevices;
    function GetAsJSON: TJSONObject;
    procedure SetAsJSON(const Value: TJSONObject);
    procedure SetDevices(const Value: TASSCGDBDevices);
    procedure SetEnabled(const Value: boolean);
    procedure SetName(const Value: string);
  protected
  public
    property Name: string read FName write SetName;
    property Devices: TASSCGDBDevices read FDevices write SetDevices;
    property Enabled: boolean read FEnabled write SetEnabled;
    property AsJSON: TJSONObject read GetAsJSON write SetAsJSON;
    constructor Create(AJSON: TJSONObject); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;

  TASSCGDBStores = class(TObjectList<TASSCGDBStore>)
  private
    function GetAsJSON: TJSONArray;
    function GetAsString: string;
    procedure SetAsJSON(const Value: TJSONArray);
    procedure SetAsString(const Value: string);
  protected
  public
    property AsString: string read GetAsString write SetAsString;
    property AsJSON: TJSONArray read GetAsJSON write SetAsJSON;
    procedure LoadFromFile(AFilename: string);
    procedure SaveToFile(AFilename: string);
    procedure LoadFromURL(AURL: string; onLoaded: TProc; onError: TProc = nil);
  end;

implementation

uses
  System.IOUtils,
  u_download;

{ TASSCGDBImageSize }

constructor TASSCGDBImageSize.Create(AJSON: TJSONObject);
begin
  Create;
  AsJSON := AJSON;
end;

constructor TASSCGDBImageSize.Create;
begin
  inherited Create;
  FEnabled := true;
  FWidth := 0;
  FHeight := 0;
end;

function TASSCGDBImageSize.GetAsJSON: TJSONObject;
begin
  result := TJSONObject.Create.AddPair('w', FWidth).AddPair('h', FHeight)
    .AddPair('e', FEnabled);
end;

procedure TASSCGDBImageSize.SetAsJSON(const Value: TJSONObject);
begin
  if not Value.TryGetValue<integer>('w', FWidth) then
    FWidth := 0;
  if not Value.TryGetValue<integer>('h', FHeight) then
    FHeight := 0;
  if not Value.TryGetValue<boolean>('e', FEnabled) then
    FEnabled := true;
end;

procedure TASSCGDBImageSize.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
end;

procedure TASSCGDBImageSize.SetHeight(const Value: integer);
begin
  FHeight := Value;
end;

procedure TASSCGDBImageSize.SetWidth(const Value: integer);
begin
  FWidth := Value;
end;

{ TASSCGDBImageSizes }

function TASSCGDBImageSizes.GetAsJSON: TJSONArray;
var
  i: integer;
begin
  result := TJSONArray.Create;
  for i := 0 to count - 1 do
    result.add(self[i].AsJSON);
end;

procedure TASSCGDBImageSizes.SetAsJSON(const Value: TJSONArray);
var
  jsv: TJSONValue;
begin
  clear;
  for jsv in Value do
    add(TASSCGDBImageSize.Create(jsv as TJSONObject));
end;

{ TASSCGDBDevice }

constructor TASSCGDBDevice.Create(AJSON: TJSONObject);
begin
  Create;
  AsJSON := AJSON;
end;

constructor TASSCGDBDevice.Create;
begin
  inherited Create;
  FisNeeded := false;
  FName := '';
  FEnabled := true;
  FImageType := TASSCGDBImageType.JPG;
  FImageSizes := TASSCGDBImageSizes.Create;
end;

destructor TASSCGDBDevice.Destroy;
begin
  FImageSizes.free;
  inherited;
end;

function TASSCGDBDevice.GetAsJSON: TJSONObject;
begin
  result := TJSONObject.Create.AddPair('l', FName).AddPair('n', FisNeeded)
    .AddPair('t', ord(FImageType)).AddPair('e', FEnabled)
    .AddPair('s', FImageSizes.AsJSON);
end;

procedure TASSCGDBDevice.SetAsJSON(const Value: TJSONObject);
var
  i: integer;
  jsa: TJSONArray;
begin
  if not Value.TryGetValue<string>('l', FName) then
    FName := '';

  if not Value.TryGetValue<boolean>('n', FisNeeded) then
    FisNeeded := false;

  if not Value.TryGetValue<boolean>('e', FEnabled) then
    FEnabled := true;

  if not Value.TryGetValue<integer>('t', i) then
    FImageType := TASSCGDBImageType.JPG
  else
    FImageType := TASSCGDBImageType(i);

  if not Value.TryGetValue<TJSONArray>('s', jsa) then
    FImageSizes.clear
  else
    FImageSizes.AsJSON := jsa;
end;

procedure TASSCGDBDevice.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
end;

procedure TASSCGDBDevice.SetImageSizes(const Value: TASSCGDBImageSizes);
begin
  FImageSizes := Value;
end;

procedure TASSCGDBDevice.SetImageType(const Value: TASSCGDBImageType);
begin
  FImageType := Value;
end;

procedure TASSCGDBDevice.SetisNeeded(const Value: boolean);
begin
  FisNeeded := Value;
end;

procedure TASSCGDBDevice.SetName(const Value: string);
begin
  FName := Value;
end;

{ TASSCGDBDevices }

function TASSCGDBDevices.GetAsJSON: TJSONArray;
var
  i: integer;
begin
  result := TJSONArray.Create;
  for i := 0 to count - 1 do
    result.add(self[i].AsJSON);
end;

procedure TASSCGDBDevices.SetAsJSON(const Value: TJSONArray);
var
  jsv: TJSONValue;
begin
  clear;
  for jsv in Value do
    add(TASSCGDBDevice.Create(jsv as TJSONObject));
end;

{ TASSCGDBStore }

constructor TASSCGDBStore.Create(AJSON: TJSONObject);
begin
  Create;
  AsJSON := AJSON;
end;

constructor TASSCGDBStore.Create;
begin
  inherited Create;
  FName := '';
  FEnabled := true;
  FDevices := TASSCGDBDevices.Create;
end;

destructor TASSCGDBStore.Destroy;
begin
  FDevices.free;
  inherited;
end;

function TASSCGDBStore.GetAsJSON: TJSONObject;
begin
  result := TJSONObject.Create.AddPair('l', FName).AddPair('e', FEnabled)
    .AddPair('d', FDevices.AsJSON);
end;

procedure TASSCGDBStore.SetAsJSON(const Value: TJSONObject);
var
  i: integer;
  jsa: TJSONArray;
begin
  if not Value.TryGetValue<string>('l', FName) then
    FName := '';

  if not Value.TryGetValue<boolean>('e', FEnabled) then
    FEnabled := true;

  if not Value.TryGetValue<TJSONArray>('d', jsa) then
    FDevices.clear
  else
    FDevices.AsJSON := jsa;
end;

procedure TASSCGDBStore.SetDevices(const Value: TASSCGDBDevices);
begin
  FDevices := Value;
end;

procedure TASSCGDBStore.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
end;

procedure TASSCGDBStore.SetName(const Value: string);
begin
  FName := Value;
end;

{ TASSCGDBStores }

function TASSCGDBStores.GetAsJSON: TJSONArray;
var
  i: integer;
begin
  result := TJSONArray.Create;
  for i := 0 to count - 1 do
    result.add(self[i].AsJSON);
end;

function TASSCGDBStores.GetAsString: string;
var
  jsa: TJSONArray;
begin
  jsa := AsJSON;
  try
    result := jsa.ToJSON;
  finally
    jsa.free;
  end;
end;

procedure TASSCGDBStores.LoadFromFile(AFilename: string);
begin
  if AFilename.isempty then
    raise exception.Create('No file name to load.');

  if not tfile.exists(AFilename) then
    raise exception.Create('This file doesn''t exist !');

  try
    AsString := tfile.ReadAllText(AFilename, tencoding.UTF8);
  except
    raise exception.Create('Wrong file format.');
  end;
end;

procedure TASSCGDBStores.LoadFromURL(AURL: string; onLoaded, onError: TProc);
var
  tempfn: string;
begin
  tempfn := tdownload_file.temporaryFileName('asscgstores-' + random(maxint)
    .ToString + '.json');
  try
    tdownload_file.download(AURL, tempfn,
      procedure
      begin
        try
          LoadFromFile(tempfn);
          if tfile.exists(tempfn) then
            tfile.Delete(tempfn);
          if assigned(onLoaded) then
            onLoaded;
        except
{$IF not Defined(DEBUG)}
          if tfile.exists(tempfn) then
            tfile.Delete(tempfn);
{$ENDIF}
          if assigned(onError) then
            onError;
        end;
      end,
      procedure
      begin
{$IF not Defined(DEBUG)}
        if tfile.exists(tempfn) then
          tfile.Delete(tempfn);
{$ENDIF}
        if assigned(onError) then
          onError;
      end);
  except
{$IF not Defined(DEBUG)}
    if tfile.exists(tempfn) then
      tfile.Delete(tempfn);
{$ENDIF}
    raise;
  end;
end;

procedure TASSCGDBStores.SaveToFile(AFilename: string);
begin
  if AFilename.isempty then
    raise exception.Create('No file name to load.');

  tfile.WriteAllText(AFilename, AsString, tencoding.UTF8);
end;

procedure TASSCGDBStores.SetAsJSON(const Value: TJSONArray);
var
  jsv: TJSONValue;
begin
  clear;
  for jsv in Value do
    add(TASSCGDBStore.Create(jsv as TJSONObject));
end;

procedure TASSCGDBStores.SetAsString(const Value: string);
var
  jsa: TJSONArray;
begin
  try
    jsa := TJSONArray.ParseJSONValue(Value) as TJSONArray;
  except
    raise exception.Create('Wrong JSON format.');
  end;
  if assigned(jsa) then
    try
      AsJSON := jsa;
    finally
      jsa.free;
    end
  else
    raise exception.Create('Wrong JSON format.');
end;

initialization

randomize;

end.
