unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  Olf.FMX.AboutDialog,
  uDMProjectIcon,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  uProjectASSCGStores,
  FMX.Objects,
  FMX.ListBox,
  FMX.Edit;

type
  TfrmMain = class(TForm)
    OlfAboutDialog1: TOlfAboutDialog;
    lBoutonsMenu: TLayout;
    btnOpenLocalDB: TButton;
    btnOpenWebSiteDB: TButton;
    btnQuitter: TButton;
    btnAbout: TButton;
    AjaxBackground: TRectangle;
    lHomeScreen: TLayout;
    lStoresScreen: TLayout;
    lDevicesScreen: TLayout;
    lImageSizesScreen: TLayout;
    tbStoresFooter: TToolBar;
    btnCancel: TButton;
    btnOk: TButton;
    btnExport: TButton;
    lbStores: TListBox;
    tbHeader: TToolBar;
    lblTitle: TLabel;
    lStoresLeft: TLayout;
    gplStores: TGridPanelLayout;
    btnStoreAdd: TButton;
    lStoresRight: TLayout;
    lblStoreName: TLabel;
    edtStoreName: TEdit;
    cbStoreEnabled: TCheckBox;
    GridPanelLayout1: TGridPanelLayout;
    btnStoreOk: TButton;
    btnStoreCancel: TButton;
    btnStoreDelete: TButton;
    btnShowDevices: TButton;
    lDevicesLeft: TLayout;
    lbDevices: TListBox;
    GridPanelLayout2: TGridPanelLayout;
    btnDeviceAdd: TButton;
    lImageSizesLeft: TLayout;
    lbImageSizes: TListBox;
    GridPanelLayout3: TGridPanelLayout;
    btnImageSizeAdd: TButton;
    lImageSizesRight: TLayout;
    cbImageSizeEnabled: TCheckBox;
    GridPanelLayout4: TGridPanelLayout;
    btnImageSizeOk: TButton;
    btnImageSizeCancel: TButton;
    btnImageSizeDelete: TButton;
    lDevicesRight: TLayout;
    lblDeviceName: TLabel;
    edtDeviceName: TEdit;
    cbDeviceEnabled: TCheckBox;
    GridPanelLayout5: TGridPanelLayout;
    btnDeviceOk: TButton;
    btnDeviceCancel: TButton;
    btnDeviceDelete: TButton;
    btnShowImageSizes: TButton;
    cbDeviceIsNeeded: TCheckBox;
    gplDeviceImageType: TGridPanelLayout;
    rbDeviceImageTypeJPEG: TRadioButton;
    rbDeviceImageTypePNG: TRadioButton;
    btnBackToStores: TButton;
    btnBackToDevices: TButton;
    gplImageSizesWidthHeight: TGridPanelLayout;
    edtImageSizeWidth: TEdit;
    edtImageSizeHeight: TEdit;
    lblFolderName: TLabel;
    edtDeviceFolderName: TEdit;
    edtStoreFolderName: TEdit;
    lblStoreFolderName: TLabel;
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure FormCreate(Sender: TObject);
    procedure btnQuitterClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnOpenLocalDBClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOpenWebSiteDBClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnOkClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnStoreAddClick(Sender: TObject);
    procedure lbStoresChange(Sender: TObject);
    procedure btnShowDevicesClick(Sender: TObject);
    procedure btnStoreDeleteClick(Sender: TObject);
    procedure btnStoreCancelClick(Sender: TObject);
    procedure btnStoreOkClick(Sender: TObject);
    procedure btnDeviceOkClick(Sender: TObject);
    procedure btnDeviceCancelClick(Sender: TObject);
    procedure btnDeviceDeleteClick(Sender: TObject);
    procedure btnShowImageSizesClick(Sender: TObject);
    procedure btnDeviceAddClick(Sender: TObject);
    procedure lbDevicesChange(Sender: TObject);
    procedure btnImageSizeAddClick(Sender: TObject);
    procedure lbImageSizesChange(Sender: TObject);
    procedure btnImageSizeOkClick(Sender: TObject);
    procedure btnImageSizeCancelClick(Sender: TObject);
    procedure btnImageSizeDeleteClick(Sender: TObject);
    procedure btnBackToDevicesClick(Sender: TObject);
    procedure btnBackToStoresClick(Sender: TObject);
  private
    FCurrentDisplay: TLayout;
    FCurrentDB: TASSCGDBStores;
    { Déclarations privées }
    function GetLocalDBFolder: string;
    function GetLocalDBFilePath: string;
    procedure initMenuButtons;
    procedure SetCurrentDB(const Value: TASSCGDBStores);
    procedure SetCurrentDisplay(const Value: TLayout);
    procedure GoToHomeScreen;
    procedure GoToStoresScreen;
    procedure GoToDevicesScreen;
    procedure GoToImageSizesScreen;
    function AddStoreToListbox(Const AStore: TASSCGDBStore): tlistboxitem;
    function AddDeviceToListbox(Const ADevice: TASSCGDBDevice): tlistboxitem;
    function AddImageSizeToListbox(Const AImageSize: TASSCGDBImageSize)
      : tlistboxitem;
    procedure InitFieldsFromCurrentStore;
    procedure InitFieldsFromCurrentDevice;
    procedure InitFieldsFromCurrentImageSize;
    procedure InitListBoxItemFromStore(AItem: tlistboxitem;
      AStore: TASSCGDBStore);
    procedure InitListBoxItemFromDevice(AItem: tlistboxitem;
      ADevice: TASSCGDBDevice);
    procedure InitListBoxItemFromImageSize(AItem: tlistboxitem;
      AImageSize: TASSCGDBImageSize);
  protected
    FCurrentStore: TASSCGDBStore;
    FCurrentDevice: TASSCGDBDevice;
    FCurrentImageSize: TASSCGDBImageSize;
  public
    { Déclarations publiques }
    property CurrentDB: TASSCGDBStores read FCurrentDB write SetCurrentDB;
    property CurrentDisplay: TLayout read FCurrentDisplay
      write SetCurrentDisplay;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.IOUtils,
  u_urlOpen,
  uAjaxAnimation;

function TfrmMain.AddDeviceToListbox(const ADevice: TASSCGDBDevice)
  : tlistboxitem;
begin
  result := tlistboxitem.Create(self);
  InitListBoxItemFromDevice(result, ADevice);
  lbDevices.AddObject(result);
end;

function TfrmMain.AddImageSizeToListbox(const AImageSize: TASSCGDBImageSize)
  : tlistboxitem;
begin
  result := tlistboxitem.Create(self);
  InitListBoxItemFromImageSize(result, AImageSize);
  lbImageSizes.AddObject(result);
end;

procedure TfrmMain.InitFieldsFromCurrentDevice;
begin
  edtDeviceName.Text := FCurrentDevice.Name;
  edtDeviceFolderName.Text := FCurrentDevice.folderName;
  cbDeviceEnabled.IsChecked := FCurrentDevice.Enabled;
  case FCurrentDevice.ImageType of
    TASSCGDBImageType.JPG:
      rbDeviceImageTypeJPEG.IsChecked := true;
    TASSCGDBImageType.png:
      rbDeviceImageTypePNG.IsChecked := true;
  else
    raise exception.Create('Image type ' + ord(FCurrentDevice.ImageType)
      .ToString + ' not supported. Please update your software.');
  end;
  cbDeviceIsNeeded.IsChecked := FCurrentDevice.isNeeded;
end;

procedure TfrmMain.InitFieldsFromCurrentImageSize;
begin
  edtImageSizeWidth.Text := FCurrentImageSize.Width.ToString;
  edtImageSizeHeight.Text := FCurrentImageSize.Height.ToString;
  cbImageSizeEnabled.IsChecked := FCurrentImageSize.Enabled;
end;

procedure TfrmMain.InitFieldsFromCurrentStore;
begin
  edtStoreName.Text := FCurrentStore.Name;
  edtStoreFolderName.Text := FCurrentStore.folderName;
  cbStoreEnabled.IsChecked := FCurrentStore.Enabled;
end;

procedure TfrmMain.InitListBoxItemFromDevice(AItem: tlistboxitem;
  ADevice: TASSCGDBDevice);
begin
  AItem.Text := ADevice.Name;
  AItem.TagObject := ADevice;

  AItem.StyledSettings := AItem.StyledSettings - [TStyledSetting.style];

  if not ADevice.Enabled then
    AItem.TextSettings.Font.style := AItem.TextSettings.Font.style +
      [TFontStyle.fsStrikeOut]
  else
    AItem.TextSettings.Font.style := AItem.TextSettings.Font.style -
      [TFontStyle.fsStrikeOut];

  if ADevice.isNeeded then
    AItem.TextSettings.Font.style := AItem.TextSettings.Font.style +
      [TFontStyle.fsBold]
  else
    AItem.TextSettings.Font.style := AItem.TextSettings.Font.style -
      [TFontStyle.fsBold];
end;

procedure TfrmMain.InitListBoxItemFromImageSize(AItem: tlistboxitem;
  AImageSize: TASSCGDBImageSize);
begin
  AItem.Text := AImageSize.Width.ToString + ' x ' + AImageSize.Height.ToString;
  AItem.TagObject := AImageSize;

  AItem.StyledSettings := AItem.StyledSettings - [TStyledSetting.style];

  if not AImageSize.Enabled then
    AItem.TextSettings.Font.style := AItem.TextSettings.Font.style +
      [TFontStyle.fsStrikeOut]
  else
    AItem.TextSettings.Font.style := AItem.TextSettings.Font.style -
      [TFontStyle.fsStrikeOut];
end;

procedure TfrmMain.InitListBoxItemFromStore(AItem: tlistboxitem;
  AStore: TASSCGDBStore);
begin
  AItem.Text := AStore.Name;
  AItem.TagObject := AStore;

  AItem.StyledSettings := AItem.StyledSettings - [TStyledSetting.style];

  if not AStore.Enabled then
    AItem.TextSettings.Font.style := AItem.TextSettings.Font.style +
      [TFontStyle.fsStrikeOut]
  else
    AItem.TextSettings.Font.style := AItem.TextSettings.Font.style -
      [TFontStyle.fsStrikeOut];
end;

function TfrmMain.AddStoreToListbox(const AStore: TASSCGDBStore): tlistboxitem;
begin
  result := tlistboxitem.Create(self);
  InitListBoxItemFromStore(result, AStore);
  lbStores.AddObject(result);
end;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  OlfAboutDialog1.Execute;
end;

procedure TfrmMain.btnBackToDevicesClick(Sender: TObject);
begin
  // TODO : vérifier que rien n'a été modifié dans cet écran avant de changer
  GoToDevicesScreen;
end;

procedure TfrmMain.btnBackToStoresClick(Sender: TObject);
begin
  // TODO : vérifier que rien n'a été modifié dans cet écran avant de changer
  GoToStoresScreen;
end;

procedure TfrmMain.btnCancelClick(Sender: TObject);
begin
  CurrentDB := nil;
  GoToHomeScreen;
end;

procedure TfrmMain.btnDeviceAddClick(Sender: TObject);
var
  Device: TASSCGDBDevice;
begin
  Device := TASSCGDBDevice.Create;
  Device.Name := 'new device';
  FCurrentStore.devices.Add(Device);
  lbDevices.ItemIndex := AddDeviceToListbox(Device).Index;
end;

procedure TfrmMain.btnDeviceCancelClick(Sender: TObject);
begin
  InitFieldsFromCurrentDevice;
end;

procedure TfrmMain.btnDeviceDeleteClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmMain.btnDeviceOkClick(Sender: TObject);
begin
  if edtDeviceName.Text.isempty then
    raise exception.Create('A device needs a name !');

  FCurrentDevice.Name := edtDeviceName.Text;
  FCurrentDevice.folderName := edtDeviceFolderName.Text;
  FCurrentDevice.Enabled := cbDeviceEnabled.IsChecked;
  if rbDeviceImageTypeJPEG.IsChecked then
    FCurrentDevice.ImageType := TASSCGDBImageType.JPG
  else if rbDeviceImageTypePNG.IsChecked then
    FCurrentDevice.ImageType := TASSCGDBImageType.png;
  FCurrentDevice.isNeeded := cbDeviceIsNeeded.IsChecked;

  InitListBoxItemFromDevice(lbDevices.selected, FCurrentDevice);
end;

procedure TfrmMain.btnExportClick(Sender: TObject);
var
  Folder, Filename: string;
begin
  // TODO : à remplacer par une demande du dossier de stockage
{$IFDEF DEBUG}
{$IFDEF MSWINDOWS}
  Folder := 'C:\xampp\htdocs\asscgdb';
{$ELSE}
  Folder := tpath.GetDownloadsPath;
{$ENDIF}
{$ELSE}
  Folder := tpath.GetDownloadsPath;
{$ENDIF}
  Filename := tpath.combine(Folder, 'storesdb.json');
  CurrentDB.SaveToFile(Filename);
  ShowMessage('DB exported to file ' + Filename);
end;

procedure TfrmMain.btnImageSizeAddClick(Sender: TObject);
var
  ImageSize: TASSCGDBImageSize;
begin
  ImageSize := TASSCGDBImageSize.Create;
  FCurrentDevice.ImageSizes.Add(ImageSize);
  lbImageSizes.ItemIndex := AddImageSizeToListbox(ImageSize).Index;
end;

procedure TfrmMain.btnImageSizeCancelClick(Sender: TObject);
begin
  InitFieldsFromCurrentImageSize;
end;

procedure TfrmMain.btnImageSizeDeleteClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmMain.btnImageSizeOkClick(Sender: TObject);
begin
  if edtImageSizeWidth.Text.isempty then
    raise exception.Create('The width is needed !');

  if edtImageSizeHeight.Text.isempty then
    raise exception.Create('The height is needed !');

  FCurrentImageSize.Width := edtImageSizeWidth.Text.ToInteger;
  FCurrentImageSize.Height := edtImageSizeHeight.Text.ToInteger;
  FCurrentImageSize.Enabled := cbImageSizeEnabled.IsChecked;

  InitListBoxItemFromImageSize(lbImageSizes.selected, FCurrentImageSize);
end;

procedure TfrmMain.btnOkClick(Sender: TObject);
var
  Folder: string;
begin
  Folder := GetLocalDBFolder;
  if not TDirectory.Exists(Folder) then
    TDirectory.CreateDirectory(Folder);

  CurrentDB.SaveToFile(GetLocalDBFilePath);

  GoToHomeScreen;
end;

procedure TfrmMain.btnOpenLocalDBClick(Sender: TObject);
var
  Filename: string;
begin
  Filename := GetLocalDBFilePath;
  if tfile.Exists(Filename) then
  begin
    CurrentDB := TASSCGDBStores.Create;
    CurrentDB.LoadFromFile(Filename);
    GoToStoresScreen;
  end
  else
    btnOpenWebSiteDBClick(Sender);
end;

procedure TfrmMain.btnOpenWebSiteDBClick(Sender: TObject);
begin
  btnOpenLocalDB.Enabled := false;
  btnOpenWebSiteDB.Enabled := false;
  ajax_animation_on;
  try
    CurrentDB := TASSCGDBStores.Create;
    CurrentDB.LoadFromURL(CASSCGDBURL,
      procedure
      begin
        try
          GoToStoresScreen;
        finally
          ajax_animation_off(true);
        end;
      end,
      procedure
      begin
        initMenuButtons;
        ajax_animation_off(true);
        ShowMessage('download error');
      end);
  except
    initMenuButtons;
    ajax_animation_off(true);
    raise;
  end;
end;

procedure TfrmMain.btnQuitterClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.btnShowDevicesClick(Sender: TObject);
begin
  // TODO : si store modifié, proposer son enregistrement avant de partir
  FCurrentDevice := nil;
  GoToDevicesScreen;
end;

procedure TfrmMain.btnShowImageSizesClick(Sender: TObject);
begin
  // TODO : si device modifié, proposer son enregistrement avant de partir
  FCurrentImageSize := nil;
  GoToImageSizesScreen;
end;

procedure TfrmMain.btnStoreAddClick(Sender: TObject);
var
  store: TASSCGDBStore;
begin
  store := TASSCGDBStore.Create;
  store.Name := 'new store';
  CurrentDB.Add(store);
  lbStores.ItemIndex := AddStoreToListbox(store).Index;
end;

procedure TfrmMain.btnStoreCancelClick(Sender: TObject);
begin
  InitFieldsFromCurrentStore;
end;

procedure TfrmMain.btnStoreDeleteClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmMain.btnStoreOkClick(Sender: TObject);
begin
  if edtStoreName.Text.isempty then
    raise exception.Create('A store needs a name !');

  FCurrentStore.Name := edtStoreName.Text;
  FCurrentStore.folderName := edtStoreFolderName.Text;
  FCurrentStore.Enabled := cbStoreEnabled.IsChecked;

  InitListBoxItemFromStore(lbStores.selected, FCurrentStore);
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // TODO : si un fichier est ouvert, proposer son enregistrement
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  o: TFmxObject;
begin
  caption := OlfAboutDialog1.Titre + ' v' + OlfAboutDialog1.VersionNumero;
{$IFDEF DEBUG}
  caption := '[DEBUG] ' + caption;
{$ENDIF}
  FCurrentDB := nil;
  AjaxBackground.Visible := false;
  ajax_animation_set(AjaxBackground);
  FCurrentDisplay := nil;
  // Masque les TLayout servant d'écrans
  for o in Children do
    if (o is TLayout) and
      (string((o as TLayout).Name).ToLower.EndsWith('screen')) then
      (o as TLayout).Visible := false;
  // Bascule sur l'écran d'accueil
  GoToHomeScreen;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  CurrentDB.free;
end;

function TfrmMain.GetLocalDBFilePath: string;
begin
{$IFDEF DEBUG}
  result := tpath.combine(GetLocalDBFolder, 'asscg-debug.asscgstores');
{$ELSE}
  result := tpath.combine(GetLocalDBFolder, 'asscg.asscgstores');
{$ENDIF}
end;

function TfrmMain.GetLocalDBFolder: string;
begin
{$IFDEF DEBUG}
  result := tpath.combine(tpath.getdocumentspath, 'OlfSoftware-DEBUG',
    'ASSCGDB-DEBUG');
{$ELSE}
  result := tpath.combine(tpath.GetHomePath, 'OlfSoftware', 'ASSCGDB');
{$ENDIF}
end;

procedure TfrmMain.GoToDevicesScreen;
var
  i: integer;
  Item: tlistboxitem;
begin
  tbHeader.Visible := true;
  lblTitle.Text := 'Devices for store "' + FCurrentStore.Name + '"';
  btnBackToStores.Visible := true;
  btnBackToDevices.Visible := false;
  lDevicesRight.Visible := false;
  lbDevices.Clear;
  for i := 0 to FCurrentStore.devices.count - 1 do
  begin
    Item := AddDeviceToListbox(FCurrentStore.devices[i]);
    if assigned(FCurrentDevice) and (FCurrentDevice = Item.TagObject) then
      lbDevices.ItemIndex := Item.Index;
  end;
  CurrentDisplay := lDevicesScreen;
end;

procedure TfrmMain.GoToHomeScreen;
begin
  tbHeader.Visible := false;
  initMenuButtons;
  CurrentDisplay := lHomeScreen;
end;

procedure TfrmMain.GoToImageSizesScreen;
var
  i: integer;
  Item: tlistboxitem;
begin
  tbHeader.Visible := true;
  lblTitle.Text := 'Image sizes for device "' + FCurrentDevice.Name + '"';
  btnBackToStores.Visible := true;
  btnBackToDevices.Visible := true;
  lImageSizesRight.Visible := false;
  lbImageSizes.Clear;
  for i := 0 to FCurrentDevice.ImageSizes.count - 1 do
  begin
    Item := AddImageSizeToListbox(FCurrentDevice.ImageSizes[i]);
    if assigned(FCurrentImageSize) and (FCurrentImageSize = Item.TagObject) then
      lbImageSizes.ItemIndex := Item.Index;
  end;
  CurrentDisplay := lImageSizesScreen;
end;

procedure TfrmMain.initMenuButtons;
begin
  btnOpenLocalDB.Enabled := tfile.Exists(GetLocalDBFilePath);
  btnOpenWebSiteDB.Enabled := true;
end;

procedure TfrmMain.lbDevicesChange(Sender: TObject);
begin
  if assigned(lbDevices.selected) then
  begin
    FCurrentDevice := lbDevices.selected.TagObject as TASSCGDBDevice;
    InitFieldsFromCurrentDevice;
    lDevicesRight.Visible := true;
  end
  else
    lDevicesRight.Visible := false;
end;

procedure TfrmMain.lbImageSizesChange(Sender: TObject);
begin
  if assigned(lbImageSizes.selected) then
  begin
    FCurrentImageSize := lbImageSizes.selected.TagObject as TASSCGDBImageSize;
    InitFieldsFromCurrentImageSize;
    lImageSizesRight.Visible := true;
  end
  else
    lImageSizesRight.Visible := false;
end;

procedure TfrmMain.lbStoresChange(Sender: TObject);
begin
  if assigned(lbStores.selected) then
  begin
    FCurrentStore := lbStores.selected.TagObject as TASSCGDBStore;
    InitFieldsFromCurrentStore;
    lStoresRight.Visible := true;
  end
  else
    lStoresRight.Visible := false;
end;

procedure TfrmMain.GoToStoresScreen;
var
  i: integer;
  Item: tlistboxitem;
begin
  tbHeader.Visible := true;
  lblTitle.Text := 'Stores';
  btnBackToStores.Visible := false;
  btnBackToDevices.Visible := false;
  lStoresRight.Visible := false;
  lbStores.Clear;
  for i := 0 to CurrentDB.count - 1 do
  begin
    Item := AddStoreToListbox(CurrentDB[i]);
    if assigned(FCurrentStore) and (FCurrentStore = Item.TagObject) then
      lbStores.ItemIndex := Item.Index;
  end;
  CurrentDisplay := lStoresScreen;
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

procedure TfrmMain.SetCurrentDB(const Value: TASSCGDBStores);
begin
  if FCurrentDB <> Value then
  begin
    FCurrentDB.free;
    FCurrentStore := nil;
    FCurrentDevice := nil;
  end;

  FCurrentDB := Value;
end;

procedure TfrmMain.SetCurrentDisplay(const Value: TLayout);
begin
  if assigned(FCurrentDisplay) then
    FCurrentDisplay.Visible := false;

  FCurrentDisplay := Value;

  if assigned(FCurrentDisplay) then
    FCurrentDisplay.Visible := true;
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
