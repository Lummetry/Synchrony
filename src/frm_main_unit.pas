unit frm_main_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { Tfrm_main }

  Tfrm_main = class(TForm)
    frm_new: TBitBtn;
    frm_sync: TBitBtn;
    frm_config: TBitBtn;
    frm_exit: TBitBtn;
    procedure frm_exitClick(Sender: TObject);
    procedure frm_formularClick(Sender: TObject);
    procedure frm_newClick(Sender: TObject);
  private

  public

  end;

var
  frm_main: Tfrm_main;

implementation

{$R *.lfm}

uses frm_cedicrom_unit;

{ Tfrm_main }

procedure Tfrm_main.frm_formularClick(Sender: TObject);
begin
end;

procedure Tfrm_main.frm_newClick(Sender: TObject);
begin
  frm_cedricrom.showModal;
end;

procedure Tfrm_main.frm_exitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.

