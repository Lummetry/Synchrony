unit frm_config_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons;

type

  { Tfrm_config }

  Tfrm_config = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
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
  frm_debug.ShowModal;
end;

procedure Tfrm_config.BitBtn3Click(Sender: TObject);
begin
  db_save_file;
end;

end.

