unit frm_config_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls;

type

  { Tfrm_config }

  Tfrm_config = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BG_config: TImage;
    BitBtn6: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
  private

  public

  end;

var
  frm_config: Tfrm_config;

implementation

uses frm_debug_unit, sync_utils;

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

end.

