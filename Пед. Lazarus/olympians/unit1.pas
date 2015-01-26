unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids;

type

  { TMainForm }

  TMainForm = class(TForm)
    exitButton: TButton;
    sortButton: TButton;
    makeCalculation: TButton;
    calculationResult: TStaticText;
    olympiansGrid: TStringGrid;
    olympiansLabel: TLabel;
    olympiansCountEdit: TEdit;
    specifyOlympiansCountLabel: TLabel;
    procedure exitButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InitializeOlympiansGrid;
    procedure makeCalculationClick(Sender: TObject);
    procedure sortButtonClick(Sender: TObject);
    procedure olympiansGridCompareCells(Sender: TObject; ACol, ARow, BCol,
      BRow: Integer; var Result: integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.exitButtonClick(Sender: TObject);
begin
     MainForm.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
     InitializeOlympiansGrid;

end;

procedure TMainForm.InitializeOlympiansGrid;
begin
    olympiansGrid.cells[1, 1] := 'Канавкин Игроль Геннадьевич';
    olympiansGrid.cells[2, 1] := '12';

    olympiansGrid.cells[1, 2] := 'Седовласов Кирилл Олегович';
    olympiansGrid.cells[2, 2] := '10';

    olympiansGrid.cells[1, 3] := 'Платинов Данил Данилович';
    olympiansGrid.cells[2, 3] := '15';

    olympiansGrid.cells[1, 4] := 'Бобров Алексей Максимович';
    olympiansGrid.cells[2, 4] := '10';

    olympiansGrid.cells[1, 5] := 'Пожарский Дмитрий Илларионович';
    olympiansGrid.cells[2, 5] := '2';

    olympiansGrid.cells[1, 6] := 'Теплов Андрей Маркович';
    olympiansGrid.cells[2, 6] := '11';

    olympiansGrid.cells[1, 7] := 'Васильев Петр Иванович';
    olympiansGrid.cells[2, 7] := '4';

    olympiansGrid.cells[1, 8] := 'Высоцкий Олег Андреевич';
    olympiansGrid.cells[2, 8] := '6';

    olympiansGrid.cells[1, 9] := 'Комаров Игнат Русланович';
    olympiansGrid.cells[2, 9] := '5';

    olympiansGrid.cells[1, 10] := 'Доброделов Артем Аркадьевич';
    olympiansGrid.cells[2, 10] := '14';
end;

procedure TMainForm.makeCalculationClick(Sender: TObject);
var
   minScore, maxScore, scoreSum: integer;
   i, currentOlympianScore: integer;
   averageScore: real;
   resultTemplate: string;
   olympianCount: integer;
begin
     minScore := High(integer);
     maxScore := Low(integer);
     scoreSum := 0;
     try
       olympianCount := StrToInt(olympiansCountEdit.Text);
     except
       olympianCount := 10;
     end;
     if olympianCount > 10 then
     begin
       olympianCount := 10;
     end;
     for i := 1 to olympianCount do
     begin
          currentOlympianScore := StrToInt(olympiansGrid.cells[2, i]);
          if currentOlympianScore < minScore then
          begin
            minScore := currentOlympianScore;
          end;

          if currentOlympianScore > maxScore then
          begin
            maxScore := currentOlympianScore;
          end;

          scoreSum := scoreSum + currentOlympianScore;
     end;

     averageScore := scoreSum / olympianCount;
     resultTemplate := 'Минимальные очки: %d' + sLineBreak +
                    'Максимальные очки: %d' + sLineBreak +
                    'Средние очки: %.2f';
     calculationResult.Caption := Format(resultTemplate,
                               [minScore, maxScore, averageScore]);
end;

procedure TMainForm.sortButtonClick(Sender: TObject);
begin
  olympiansGrid.SortColRow(true, 2);
end;

procedure TMainForm.olympiansGridCompareCells(Sender: TObject; ACol, ARow, BCol,
  BRow: Integer; var Result: integer);
var
   fValue, sValue: integer;
begin
     fValue := StrToInt(olympiansGrid.Cells[ACol, ARow]);
     sValue := StrToInt(olympiansGrid.Cells[BCol, BRow]);

     Result := sValue - fValue;
end;

end.

