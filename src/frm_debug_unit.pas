unit frm_debug_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons;

type

  { Tfrm_debug }

  Tfrm_debug = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    log: TMemo;
    Panel1: TPanel;
    procedure BitBtn2Click(Sender: TObject);
  private

  public

  end;

var
  frm_debug: Tfrm_debug;

implementation

{$R *.lfm}

{ Tfrm_debug }

uses sync_utils;

procedure Tfrm_debug.BitBtn2Click(Sender: TObject);
begin
 log_add_all_data;
end;

end.

