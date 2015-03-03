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

{$R *.dfm}

procedure TMainForm.RunButtonClick(Sender: TObject);
var
  StringList: TStringList;              //объект для преобразования строки в массив
  i: integer;                           //итератор
  localMaximumIndex: integer;           //индекс последнего найденного локального максимума
  isCurElementIsLocalMaximum: boolean;  //является ли элемент локальным максимумом
begin
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
    if isCurElementIsLocalMaximum then
    begin
      //сохраняем его индекс
      localMaximumIndex := i;
    end;
  end;
  //выводим индекс последнего найденного локального максимума
  ResultLabel.Caption := IntToStr(localMaximumIndex);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //Инициализируем поле ввода
  ArrayEdit.Text := '2 12 -8,1 14,4 13,2 17,3';
end;

end.
