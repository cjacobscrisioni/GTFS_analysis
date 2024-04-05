library DMSProject;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Windows,
  Forms,
  Unit_Splash,
  Unit_About,
  Graphics;

{$R *.RES}
{$R res\DMSProjectEx.res}

function GetApplicationIconHandle: HIcon; stdcall;
begin
  Result := LoadIcon(HInstance, 'ICON_APP');
end;

function GetMainImageHandle: HBitmap; stdcall;
begin
//  Result := LoadBitmap(HInstance, 'BMP_SPLASH');
  Result := 0;
end;

function GetApplicationTitle: shortstring; stdcall;
begin
  Result := 'EU-ClueScanner';
end;

function GetApplicationCaption: shortstring; stdcall;
begin
  Result := 'EU-ClueScanner developed for EC-DG Environment and EC-JRC-IES';
end;

procedure DisplayAboutBox(hApp: HWND; AOwner: TComponent; sDMSVersion, sClientVersion, sUrl: shortstring); stdcall;
var
  hAppOrg : HWND;
begin
  hAppOrg := Application.Handle;
  Application.Handle := hApp;

  with TAboutBox.Create(AOwner, sDMSVersion, sClientVersion, sUrl) do
  begin
    ShowModal;
    Free;
  end;

  Application.Handle := hAppOrg;
end;

procedure DisplayOrHideSplashWindow(hApp: HWND; AOwner: TComponent; sClientVersion: shortstring; bShow: boolean); stdcall;
const
  hAppOrg : HWND = 0;
  frmSplash : TfrmSplash = nil;
begin
  if(bShow)
  then begin
    hAppOrg := Application.Handle;
    Application.Handle := hApp;

    frmSplash := TfrmSplash.Create(Application, sClientVersion);
    frmSplash.Show;
    frmSplash.Refresh;
  end
  else begin
    frmSplash.Close;
    frmSplash.Release;
    frmSplash := nil;
    Application.Handle := hAppOrg;
  end
end;

exports
  GetApplicationIconHandle name 'GetApplicationIconHandle',
  GetMainImageHandle name 'GetMainImageHandle',
  GetApplicationTitle name 'GetApplicationTitle',
  GetApplicationCaption name 'GetApplicationCaption',
  DisplayAboutBox name 'DisplayAboutBox',
  DisplayOrHideSplashWindow name 'DisplayOrHideSplashWindow';

end.

