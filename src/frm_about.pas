unit frm_about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { Tfrm_about_synchrony }

  Tfrm_about_synchrony = class(TForm)
    bg_about: TImage;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    copyright: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
  private

  public

  end;

var
  frm_about_synchrony: Tfrm_about_synchrony;

implementation

{$R *.lfm}

{ Tfrm_about_synchrony }

procedure Tfrm_about_synchrony.FormCreate(Sender: TObject);
begin

end;

procedure Tfrm_about_synchrony.StaticText2Click(Sender: TObject);
begin

end;

end.

