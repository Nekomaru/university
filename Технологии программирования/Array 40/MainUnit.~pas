unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    ArrayLabel: TLabel;
    ArrayEdit: TEdit;
    RunButton: TButton;
    ResultLabel: TLabel;
    RLabel: TLabel;
    REdit: TEdit;
    procedure RunButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses Math;

{$R *.dfm}

procedure TMainForm.RunButtonClick(Sender: TObject);
var
  StringList: TStringList;        //объект дл€ преобразовани€ строки в массив
  i: integer;                     //итератор
  R: real;                        //R
  mostCloseToRElement: real;      //значение элемента ближайшего к R
  mostCloseToRElementDiff: real;  //модуль разницы между ближайшим к R элементом и R
  curElement: real;               //текущий элемент
begin
  //изначально ближайший к R элемент равен бесконечности
  mostCloseToRElementDiff := Infinity;

  //считываем значение R
  R := StrToFloat(REdit.Text);

  //создаем объект, с помощью которого будем из введенной строки делать массив
  StringList := TStringList.Create;

  //указываем раздел€ющий символ
  StringList.Delimiter := ' ';
  //указываем строку, которую нужно поделить
  StringList.DelimitedText := ArrayEdit.Text;

  //берем индекс каждого элемента
  for i := 0 to StringList.Count - 1 do
  begin
    curElement := StrToFloat(StringList.Strings[i]);
    if Abs(curElement - R) < mostCloseToRElementDiff then
    begin
      mostCloseToRElement := curElement;
      mostCloseToRElementDiff := Abs(curElement - R);
    end;
  end;
  ResultLabel.Caption := FloatToStr(mostCloseToRElement);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //»нициализируем пол€ ввода
  ArrayEdit.Text := '-12,3 44 58,1 7,3';
  REdit.Text := '22';
end;

end.
