unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SyncObjs;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Shape1: TShape;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TTrainThread = class(TThread)
    Orientation: Boolean;   // true-слева направо
    Speed: Integer;         // скорость в мсек
    Owner: TComponent;      // где отображать
    constructor Create(O: TComponent; i: Integer);
  private
    flagUp, flagDown: Boolean;
    Shape: TShape;          // внешний вид
    ALabel: TLabel;         // номер поезда
  protected
    procedure Execute; override;
  end;

var
  Form1: TForm1;
  Section: TCriticalSection;

implementation

{$R *.dfm}

{ TTrainThread }

constructor TTrainThread.Create(O: TComponent; i: Integer);
begin
  Orientation := Boolean(Random(2));
  Speed := (Random(10) + 1) * 100;
  Owner := O;
  Shape := TShape.Create(Owner);
  Shape.Parent := TWinControl(Owner);
  Shape.Height := 50;
  Shape.Width := 100;
  Shape.Brush.Color := TColor(Random(High(Integer)));
  if Orientation then begin
    Shape.Left := 0;
    Shape.Top := 155;
  end
  else begin
    Shape.Left := 600;
    Shape.Top := 55;
  end;
  ALabel := TLabel.Create(Owner);
  ALabel.Parent := TWinControl(Owner);
  ALabel.Caption := IntToStr(i);
  ALabel.Height := - ALabel.Font.Height;   //Font.Size * Font.PixelsPerInch / 72
  ALabel.Width := 15;
  if Orientation then begin
    ALabel.Left := 0;
    ALabel.Top := 155;
  end
  else begin
    ALabel.Left := 600;
    ALabel.Top := 55;
  end;
  FreeOnTerminate := True;
  flagDown := True;
  inherited Create(False);
end;

procedure TTrainThread.Execute;
begin
//  Section.Enter;   //заехать в туннель сразу при появлении
  if Orientation then begin
    while Shape.Left < 600 do begin
      if (Shape.Left >= 100) and (Shape.Left <= 500) then begin
        if not flagUp then begin
          Section.Enter;   //заехать в туннель при подъезде к нему
          Shape.Top := 105;
          ALabel.Top := 105;
          flagUp := True;
          flagDown := False;
        end;
      end
      else begin
        if not flagDown then begin
          Shape.Top := 155;
          ALabel.Top := 155;
          flagDown := True;
          Section.Leave;     // выехать из туннеля
        end;
      end;
      Shape.Left := Shape.Left + 10;
      ALabel.Left := Shape.Left;
      TWinControl(Owner).Repaint;
      Sleep(Speed);
    end;
  end
  else begin
    while Shape.Left > 0 do begin
      if (Shape.Left >= 100) and (Shape.Left <= 500) then begin
        if not flagUp then begin
          Section.Enter;    //заехать в туннель
          Shape.Top := 105;
          ALabel.Top := 105;
          flagUp := True;
          flagDown := False;
        end;
      end
      else begin
        if not flagDown then begin
          Shape.Top := 55;
          ALabel.Top := 55;
          flagDown := True;
          Section.Leave;     // выехать из туннеля
        end;
      end;
      Shape.Left := Shape.Left - 10;
      ALabel.Left := Shape.Left;
      TWinControl(Owner).Repaint;
      Sleep(Speed);
    end;
  end;
//  Section.Leave;     // выехать из туннеля
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 1 to 10 do begin
    TTrainThread.Create(self, i);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  Section := TCriticalSection.Create;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Section.Free;
end;

end.
