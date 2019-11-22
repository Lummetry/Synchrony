unit frm_main_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls;

type

  { Tfrm_main }

  Tfrm_main = class(TForm)
    btn_about: TBitBtn;
    btn_new: TBitBtn;
    btn_sync: TBitBtn;
    btn_config: TBitBtn;
    btn_exit: TBitBtn;
    btn_db: TBitBtn;
    Image1: TImage;
    procedure btn_aboutClick(Sender: TObject);
    procedure btn_configClick(Sender: TObject);
    procedure btn_exitClick(Sender: TObject);
    procedure btn_syncClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frm_formularClick(Sender: TObject);
    procedure btn_newClick(Sender: TObject);
    procedure btn_dbClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private

  public

  end;

var
  frm_main: Tfrm_main;

implementation

{$R *.lfm}

uses frm_cedicrom_unit, sync_utils, frm_records_unit, db, frm_config_unit,
     frm_about, frm_debug_unit;

{ Tfrm_main }

procedure Tfrm_main.frm_formularClick(Sender: TObject);
begin
end;

procedure Tfrm_main.btn_newClick(Sender: TObject);
begin
  new_registration(frm_cedicrom, False);
end;

procedure Tfrm_main.btn_dbClick(Sender: TObject);

begin
 show_data_log;
end;

procedure Tfrm_main.StaticText1Click(Sender: TObject);
begin

end;

procedure Tfrm_main.btn_exitClick(Sender: TObject);
begin
   Close;
end;

procedure Tfrm_main.btn_syncClick(Sender: TObject);
begin

end;

procedure Tfrm_main.FormCreate(Sender: TObject);
begin
  if frm_debug = nil then
   frm_debug := Tfrm_debug.Create(Application);
end;

procedure Tfrm_main.FormShow(Sender: TObject);
begin
  if not frm_debug.Active then
   begin
     frm_debug.show;
     frm_debug.Left:=Screen.Width - frm_debug.Width;
     frm_debug.top := 0;
   end;

end;

procedure Tfrm_main.btn_configClick(Sender: TObject);
begin
  frm_config.ShowModal;
end;

procedure Tfrm_main.btn_aboutClick(Sender: TObject);
begin
   frm_about_synchrony.ShowModal;
end;

end.

