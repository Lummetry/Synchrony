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
  _clear_form(frm_cedricrom);
  frm_cedricrom.showModal;
  extract_and_save(frm_cedricrom);
  /// this is for debug only
  log_show;
end;

procedure Tfrm_main.btn_dbClick(Sender: TObject);
var
  dsrc : TDataSource;
begin
  if ds_data.Active then
  begin
    dsrc := TDataSource.Create(self);
    dsrc.DataSet := ds_data;
    frm_records.dbg.DataSource := dsrc;
    frm_records.ShowModal;
  end
  else
  begin
    ShowMessage('Nu exista data disponibile momentan');
  end;
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

