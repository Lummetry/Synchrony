unit frm_records_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBGrids;

type

  { Tfrm_records }

  Tfrm_records = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    dbg: TDBGrid;
    Panel1: TPanel;
    procedure BitBtn2Click(Sender: TObject);
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

end.

