unit frm_config_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls,
  StdCtrls;

type

  { Tfrm_config }

  Tfrm_config = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BG_config: TImage;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    GroupBox1: TGroupBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
  private

  public

  end;

var
  frm_config: Tfrm_config;

implementation

uses frm_debug_unit, sync_utils, ShellApi, Windows;

{$R *.lfm}

{ Tfrm_config }

procedure Tfrm_config.BitBtn1Click(Sender: TObject);
begin
  log_show;
end;

procedure Tfrm_config.BitBtn3Click(Sender: TObject);
var
  rec :TROID;
begin
 rec := idr_get_last_record;
end;

procedure Tfrm_config.BitBtn4Click(Sender: TObject);
begin
  idr_execute_app;
end;

procedure Tfrm_config.BitBtn5Click(Sender: TObject);
begin
  idr_stop_app;
end;

procedure Tfrm_config.BitBtn6Click(Sender: TObject);
var
  r: integer;
begin
  log_add('Exec tutorial');
  r := ShellExecute(0, 'open', 'tutorial\Tutorial.wmv',nil, nil,SW_MAXIMIZE);

  log_add('  Tutorial exec '+IntToStr(r));
end;

end.

