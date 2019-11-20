unit frm_main_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { Tfrm_main }

  Tfrm_main = class(TForm)
    btn_new: TBitBtn;
    btn_sync: TBitBtn;
    btn_config: TBitBtn;
    btn_exit: TBitBtn;
    btn_db: TBitBtn;
    procedure btn_configClick(Sender: TObject);
    procedure btn_exitClick(Sender: TObject);
    procedure btn_syncClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure frm_formularClick(Sender: TObject);
    procedure btn_newClick(Sender: TObject);
    procedure btn_dbClick(Sender: TObject);
  private

  public

  end;

var
  frm_main: Tfrm_main;

implementation

{$R *.lfm}

uses frm_cedicrom_unit, sync_utils, frm_records_unit, db, frm_config_unit;

{ Tfrm_main }

procedure Tfrm_main.frm_formularClick(Sender: TObject);
begin
end;

procedure Tfrm_main.btn_newClick(Sender: TObject);
begin
  new_registration(frm_cedicrom, True);
end;

procedure Tfrm_main.btn_dbClick(Sender: TObject);

begin
 show_data_log;
end;

procedure Tfrm_main.btn_exitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure Tfrm_main.btn_syncClick(Sender: TObject);
begin

end;

procedure Tfrm_main.FormCreate(Sender: TObject);
begin

end;

procedure Tfrm_main.btn_configClick(Sender: TObject);
begin
  frm_config.ShowModal;
end;

end.

