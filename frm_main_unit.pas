unit frm_main_unit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Tfrm_main }

  Tfrm_main = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  frm_main: Tfrm_main;

implementation

{$R *.lfm}

uses frm_cedicrom_unit;

{ Tfrm_main }

procedure Tfrm_main.Button1Click(Sender: TObject);
begin
 frm_cedricrom.showModal;
end;

end.

