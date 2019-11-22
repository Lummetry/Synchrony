unit frm_cedicrom_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ExtDlgs, Calendar, Buttons, DateTimePicker;

type

  { Tfrm_cedicrom }

  Tfrm_cedicrom = class(TForm)
    background: TImage;
    mediul: TRadioGroup;
    mediul1: TRadioGroup;
    mediul2: TRadioGroup;
    RadioGroup1: TRadioGroup;
    status_hormonal: TRadioGroup;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    RadioGroup5: TRadioGroup;
    salvare_continuare: TBitBtn;
    salvare: TBitBtn;
    salvare_inchidere: TBitBtn;
    DIU: TCheckBox;
    leucoree: TCheckBox;
    CNP1: TEdit;
    CNP2: TEdit;
    CNP10: TEdit;
    CNP11: TEdit;
    CNP12: TEdit;
    CNP4: TEdit;
    CNP3: TEdit;
    CNP6: TEdit;
    CNP5: TEdit;
    CNP7: TEdit;
    CNP8: TEdit;
    CNP13: TEdit;
    CNP9: TEdit;
    data_recoltare: TDateTimePicker;
    data_menstruatie: TDateTimePicker;
    nume: TEdit;
    centru: TEdit;
    medic: TEdit;
    biopsie_descriere: TEdit;
    prenume: TEdit;
    judet: TEdit;
    localitate: TEdit;
    strada: TEdit;
    tel: TEdit;
    cabinet: TEdit;
    medic_familie: TEdit;
    etnie: TEdit;
    Label1: TLabel;
    Title: TLabel;
    Title1: TLabel;
    Title10: TLabel;
    Title11: TLabel;
    Title14: TLabel;
    Title16: TLabel;
    Title17: TLabel;
    Title18: TLabel;
    Title19: TLabel;
    Title2: TLabel;
    Title20: TLabel;
    Title26: TLabel;
    Title3: TLabel;
    Title4: TLabel;
    Title5: TLabel;
    Title6: TLabel;
    Title7: TLabel;
    Title8: TLabel;
    Title9: TLabel;
    procedure contactChange(Sender: TObject);
    procedure CNP1Change(Sender: TObject);
    procedure frm_cedicromSizeConstraintsChange(Sender: TObject);
    procedure mediulClick(Sender: TObject);
    procedure salvare_continuareClick(Sender: TObject);
    procedure stradaChange(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure TitleClick(Sender: TObject);
  private

  public

  end;

var
  frm_cedicrom: Tfrm_cedicrom;

implementation

{$R *.lfm}

{ Tfrm_cedicrom }

uses sync_utils;

procedure Tfrm_cedicrom.TitleClick(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.Label1Click(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.CNP1Change(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.frm_cedicromSizeConstraintsChange(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.mediulClick(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.salvare_continuareClick(Sender: TObject);
begin
  save_and_reset(self);
end;

procedure Tfrm_cedicrom.contactChange(Sender: TObject);
begin

end;

procedure Tfrm_cedicrom.stradaChange(Sender: TObject);
begin

end;

end.

