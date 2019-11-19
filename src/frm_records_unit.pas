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
    dbg: TDBGrid;
    Panel1: TPanel;
  private

  public

  end;

var
  frm_records: Tfrm_records;

implementation

{$R *.lfm}

end.

