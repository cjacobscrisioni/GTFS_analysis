unit Unit_About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, jpeg;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    TopPanel: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    OKButton: TButton;
    mmoBy: TMemo;
    lblLink: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblVersion: TLabel;
    Memo1: TMemo;
    procedure OKButtonClick(Sender: TObject);
    procedure lblLinkClick(Sender: TObject);
  private
    { Private declarations }
    m_sUrl: string;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; const sDMSVersion, sClientVersion, sUrl: string); reintroduce;
  end;


implementation

{$R *.DFM}

uses
  Dialogs, Registry, DDEman;

constructor TAboutBox.Create(AOwner: TComponent; const sDMSVersion, sClientVersion, sUrl: string);
begin
  inherited Create(AOwner);

  m_sUrl           := sUrl;

  lblVersion.Caption := sDMSVersion;
end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

function GetProgramAssociation(ext: string) : string;
var
   reg: TRegistry;
   s  : string;
begin
   s           := '';
   reg         := TRegistry.Create;
   reg.RootKey := HKEY_CLASSES_ROOT;

   if reg.OpenKey('.' + ext + '\shell\open\command', false) <> false then
   begin
      // The open command has been found
      s  := reg.ReadString('');
      reg.CloseKey;
   end else
   begin
      // perhaps there is a system file pointer
      if reg.OpenKey('.' + ext, false) <> false then
      begin
         s := reg.ReadString('');
         reg.CloseKey;

         if Length(s) > 0 then
         begin
            // A system file pointer was found
            if reg.OpenKey(s + '\shell\open\command', false) <> false then
               // The open command has been found
               s := reg.ReadString('');

            reg.CloseKey;
         end;
      end;
   end;

   // Delete any command line, quotes and spaces
   if Pos('%', s) > 0 then
      Delete(s, Pos('%', s), Length(s));

   if ((Length(s) > 0) and (s[1] = '"')) then
      Delete(s, 1, 1);

   if ((Length(s) > 0) and (Pos('"', s) > 0)) then
      Delete(s, Pos('"', s), Length(s));

   while ((Length(s) > 0) and (s[Length(s)] = #32)) do
      Delete(s, Length(s), 1);

   Result := s;

   if Length(Result) = 0 then
      ShowMessage('Your registry does not have a (valid) reference to an Internet Browser!');
end; // GetProgramAssociation

procedure   StartNewBrowserWindow(url : string);
const
   MAX_PATH = 144;
var
   DDEConv  : TDDEClientConv;
   URLFired : bool;
   App,
   UpApp    : string;
   p        : array[0..MAX_PATH] of Char;
begin
   UrlFired := false;
   App      := GetProgramAssociation('HTM');
   UpApp    := Uppercase(App);
   Delete(App, Pos('.EXE', UpAPP), Length(App));

   if Pos('NETSCAPE.EXE', UpApp) > 0 then
   begin
      DDEConv                    := TDDEClientConv.Create(nil);
      DDEConv.ServiceApplication := App;

      if DDEConv.SetLink('NETSCAPE' , 'WWW_OpenURL')
         and
         Assigned(DDEConv.RequestData(url + ',,0x0,0x0'))
         and
         DDEConv.SetLink('NETSCAPE', 'WWW_Activate') then
         URLFired := Assigned(DDEConv.RequestData('0xFFFFFFFF,0x0'));

      DDEConv.Free;
   end else if Pos('IEXPLORE.EXE', UpApp) > 0 then
   begin
      DDEConv                    := TDDEClientConv.Create(nil);
      DDEConv.ServiceApplication := App;

      if DDEConv.SetLink('iexplore', 'WWW_OpenURL')
         and
         Assigned(DDEConv.RequestData(url + ',,0'))
         and
         DDEConv.SetLink('iexplore', 'WWW_Activate') then
         URLFired := Assigned(DDEConv.RequestData('0,0'));

      DDEConv.Free;
   end;

   if UrlFired = false then
      WinExec(StrPCopy(@p, url), SW_SHOWNORMAL);
end; // StartNewBrowserWindow


procedure TAboutBox.lblLinkClick(Sender: TObject);
begin
  if(m_sUrl <> '')
  then
    StartNewBrowserWindow(m_sUrl)
  else
    ShowMessage('Url not specified.');
end;

end.




