unit Unit_Splash;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, jpeg;

type
  TfrmSplash = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Label4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent; sClientVersion: string); reintroduce;
  end;

implementation

{$R *.DFM}

constructor TfrmSplash.Create(AOwner: TComponent; sClientVersion: string);
begin
  inherited Create(AOwner);

  Label4.Caption := 'build '+ sClientVersion;
end;

end.
