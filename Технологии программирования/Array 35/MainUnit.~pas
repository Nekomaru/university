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
  StringList: TStringList;              //объект для преобразования строки в массив
  i: integer;                           //итератор
  minimalLocalMaximum: real;            //минимальный локальный максимум
  isCurElementIsLocalMaximum: boolean;  //является ли элемент локальным максимумом
begin
  //изначально минимальный локальый минимум равен бесконечности
  minimalLocalMaximum := Infinity;

  //создаем объект, с помощью которого будем из введенной строки делать массив
  StringList := TStringList.Create;

  //указываем разделяющий символ
  StringList.Delimiter := ' ';
  //указываем строку, которую нужно поделить
  StringList.DelimitedText := ArrayEdit.Text;

  //берем индекс каждого элемента
  for i := 0 to StringList.Count - 1 do
  begin
    //в начале каждой итерации считаем, что элемент не является локальными максимумом
    isCurElementIsLocalMaximum := false;

    //если текущий элемент - нулевой элемент
    if i = 0 then
    begin
      //то он является локальным максимум если он больше первого элемента
      isCurElementIsLocalMaximum :=
        StrToFloat(StringList.Strings[0]) > StrToFloat(StringList.Strings[1]);
    end
    //если текущий элемент - последний элемент
    else if i = StringList.Count - 1 then
    begin
      //то он является локальным максимумом если он больше последнего элемента
      isCurElementIsLocalMaximum :=
        StrToFloat(StringList.Strings[StringList.Count - 1]) >
        StrToFloat(StringList.Strings[StringList.Count - 2]);
    end
    //иначе
    else
    begin
      //элемент является локальным максимум если он больше своих соседей
      isCurElementIsLocalMaximum :=
        (StrToFloat(StringList.Strings[i]) > StrToFloat(StringList.Strings[i - 1])) and
        (StrToFloat(StringList.Strings[i]) > StrToFloat(StringList.Strings[i + 1]));
    end;
    //если элемент является локальным максимумом
    //и меньше последнего найденного локального максимума
    if (isCurElementIsLocalMaximum) and
      (StrToFloat(StringList.Strings[i]) < minimalLocalMaximum) then
    begin
      //и его значение
      minimalLocalMaximum := StrToFloat(StringList.Strings[i]);
    end;
  end;
  //выводим минимальный локальный максимум
  ResultLabel.Caption := FloatToStr(minimalLocalMaximum);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //Инициализируем поле ввода
  ArrayEdit.Text := '2 12 -8,1 14,4 13,2 17,3';
end;

end.
