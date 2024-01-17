program ASSCG_Stores_Admin;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uProjectASSCGStores in 'uProjectASSCGStores.pas',
  u_download in '..\lib-externes\librairies\u_download.pas',
  Olf.FMX.AboutDialog in '..\lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  uDMProjectIcon in 'uDMProjectIcon.pas' {dmProjectIcon: TDataModule},
  u_urlOpen in '..\lib-externes\librairies\u_urlOpen.pas',
  uAjaxAnimation in '..\lib-externes\librairies\uAjaxAnimation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmProjectIcon, dmProjectIcon);
  Application.Run;
end.
