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
  uDMProjectIcon, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  uProjectASSCGStores, FMX.Objects;

type
  TfrmMain = class(TForm)
    OlfAboutDialog1: TOlfAboutDialog;
    Layout1: TLayout;
    btnOpenLocalDB: TButton;
    btnOpenWebSiteDB: TButton;
    btnQuitter: TButton;
    btnAbout: TButton;
    AjaxBackground: TRectangle;
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure FormCreate(Sender: TObject);
    procedure btnQuitterClick(Sender: TObject);
    procedure btnAboutClick(Sender: TObject);
    procedure btnOpenLocalDBClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOpenWebSiteDBClick(Sender: TObject);
  private
    { Déclarations privées }
    function GetLocalDBFolder: string;
    function GetLocalDBFilePath: string;
    procedure initMenuButtons;
  public
    { Déclarations publiques }
    CurrentDB: TASSCGDBStores;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.IOUtils,
  u_urlOpen,
  uAjaxAnimation;

procedure TfrmMain.btnAboutClick(Sender: TObject);
begin
  OlfAboutDialog1.Execute;
end;

procedure TfrmMain.btnOpenLocalDBClick(Sender: TObject);
var
  filename: string;
begin
  filename := GetLocalDBFilePath;
  if tfile.exists(filename) then
  begin
    CurrentDB.LoadFromFile(filename);
    // TODO : appeler fenêtre de gestion de la base de donnée
    showmessage('open ok');
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
    CurrentDB.LoadFromURL(CASSCGDBURL,
      procedure
      begin
        try
          // TODO : appeler fenêtre de gestion de la base de donnée
          showmessage('download ok');
        finally
          initMenuButtons;
          ajax_animation_off(true);
        end;
      end,
      procedure
      begin
        initMenuButtons;
        ajax_animation_off(true);
        showmessage('download error');
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

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  caption := OlfAboutDialog1.Titre + ' v' + OlfAboutDialog1.VersionNumero;
{$IFDEF DEBUG}
  caption := '[DEBUG] ' + caption;
{$ENDIF}
  CurrentDB := TASSCGDBStores.create;
  initMenuButtons;
  AjaxBackground.Visible := false;
  ajax_animation_set(AjaxBackground);
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

procedure TfrmMain.initMenuButtons;
begin
  btnOpenLocalDB.Enabled := tfile.exists(GetLocalDBFilePath);
  btnOpenWebSiteDB.Enabled := true;
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
