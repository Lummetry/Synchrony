unit frm_records_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBGrids, StdCtrls;

type

  { Tfrm_records }

  Tfrm_records = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dbg: TDBGrid;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    nrec: TLabeledEdit;
    dstart: TLabeledEdit;
    dend: TLabeledEdit;
    Panel1: TPanel;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frm_records: Tfrm_records;

implementation

{$R *.lfm}

{ Tfrm_records }

uses sync_utils;

procedure Tfrm_records.BitBtn2Click(Sender: TObject);
begin
 db_save_file;
end;

procedure Tfrm_records.FormShow(Sender: TObject);
var
  o_stat : TTwoDates;
begin
  o_stat := db_get_min_max_dates;
  nrec.Text:= IntToStr(ds_data.RecordCount);
  dstart.Text := o_stat.s_start;
  dend.Text := o_stat.s_end;
end;

end.

