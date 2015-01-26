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
    studentsGrid: TStringGrid;
    studentsLabel: TLabel;
    studentCountEdit: TEdit;
    specifyStudentCountLabel: TLabel;
    procedure exitButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InitializeStudentsGrid;
    procedure makeCalculationClick(Sender: TObject);
    procedure sortButtonClick(Sender: TObject);
    procedure studentsGridCompareCells(Sender: TObject; ACol, ARow, BCol,
      BRow: Integer; var Result: integer);
  private
    { private declarations }
  public
    { public declarations }
  end;

  TStudent = class
    name: String;
    scores: integer;
  end;

var
  MainForm: TMainForm;
  students: array [0..9] of TStudent;
implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.exitButtonClick(Sender: TObject);
begin
     MainForm.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
     InitializeStudentsGrid;

end;

procedure TMainForm.InitializeStudentsGrid;
begin
    studentsGrid.cells[1, 1] := 'Пупкини Василий Иванович';
    studentsGrid.cells[2, 1] := '87';

    studentsGrid.cells[1, 2] := 'Иванов Иван Иванович';
    studentsGrid.cells[2, 2] := '54';

    studentsGrid.cells[1, 3] := 'Сидоров Петр Константинович';
    studentsGrid.cells[2, 3] := '74';

    studentsGrid.cells[1, 4] := 'Петров Петр Петрович';
    studentsGrid.cells[2, 4] := '96';

    studentsGrid.cells[1, 5] := 'Салоедов Илья Олегович';
    studentsGrid.cells[2, 5] := '100';

    studentsGrid.cells[1, 6] := 'Краснов Олег Максимович';
    studentsGrid.cells[2, 6] := '65';

    studentsGrid.cells[1, 7] := 'Максимов Андрей Аркадьевич';
    studentsGrid.cells[2, 7] := '45';

    studentsGrid.cells[1, 8] := 'Кашеваров Станислав Викторович';
    studentsGrid.cells[2, 8] := '94';

    studentsGrid.cells[1, 9] := 'Двоечник Иван Петрович';
    studentsGrid.cells[2, 9] := '22';

    studentsGrid.cells[1, 10] := 'Митрофанов Геннадий Евгеньевич';
    studentsGrid.cells[2, 10] := '48';
end;

procedure TMainForm.makeCalculationClick(Sender: TObject);
var
   minScore, maxScore, scoreSum: integer;
   i, currentStudentScore: integer;
   averageScore: real;
   resultTemplate: string;
   studentCount: integer;
begin
     minScore := High(integer);
     maxScore := Low(integer);
     scoreSum := 0;
     try
       studentCount := StrToInt(studentCountEdit.Text);
     except
       studentCount := 10;
     end;
     if studentCount > 10 then
     begin
       studentCount := 10;
     end;
     for i := 1 to studentCount do
     begin
          currentStudentScore := StrToInt(studentsGrid.cells[2, i]);
          if currentStudentScore < minScore then
          begin
            minScore := currentStudentScore;
          end;

          if currentStudentScore > maxScore then
          begin
            maxScore := currentStudentScore;
          end;

          scoreSum := scoreSum + currentStudentScore;
     end;

     averageScore := scoreSum / studentCount;
     resultTemplate := 'Минимальный балл: %d' + sLineBreak +
                    'Максимальный балл: %d' + sLineBreak +
                    'Средний балл: %.2f';
     calculationResult.Caption := Format(resultTemplate,
                               [minScore, maxScore, averageScore]);
end;

procedure TMainForm.sortButtonClick(Sender: TObject);
begin
  studentsGrid.SortColRow(true, 2);
end;

procedure TMainForm.studentsGridCompareCells(Sender: TObject; ACol, ARow, BCol,
  BRow: Integer; var Result: integer);
var
   fValue, sValue: integer;
begin
     fValue := StrToInt(studentsGrid.Cells[ACol, ARow]);
     sValue := StrToInt(studentsGrid.Cells[BCol, BRow]);

     Result := sValue - fValue;
end;

end.

