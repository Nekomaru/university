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
  StringList: TStringList;                    //объект для преобразования строки в массив
  i: integer;                                 //итератор
  maxWantedElement: real;                     //минимальный элемент удовлетворяющий условиям
  isAtLeastOneWantedElementExist: boolean;    //существует ли хотя бы один элемент удовлетворяющий условиям
  isCurElementIsLocalExtremum: boolean;       //является ли текущий элемент локальным экстремумом
  prevElement, curElement, nextElement: real; //предыдущий, текущий и следующий элемент соответственно
begin
  //изначально ни одного элемента удовлетворяющего условиям не найдено
  isAtLeastOneWantedElementExist := false;

  //изначально максимальный искомый элемент равен минимально возможному значению
  maxWantedElement := -Infinity;

  //создаем объект, с помощью которого будем из введенной строки делать массив
  StringList := TStringList.Create;

  //указываем разделяющий символ
  StringList.Delimiter := ' ';
  //указываем строку, которую нужно поделить
  StringList.DelimitedText := ArrayEdit.Text;

  //берем индекс каждого элемента
  for i := 0 to StringList.Count - 1 do
  begin
    //в начале каждой итерации считаем, что элемент не является локальными экстремумом
    isCurElementIsLocalExtremum := false;

    //сохраняем текущий элемент в отдельную переменную
    curElement := StrToFloat(StringList.Strings[i]);

    //если текущий элемент - нулевой элемент
    if i = 0 then
    begin
      //то он является локальным экстремумом если он не равен первому элементу
      isCurElementIsLocalExtremum :=
        curElement <> StrToFloat(StringList.Strings[1]);
    end
    //если текущий элемент - последний элемент
    else if i = StringList.Count - 1 then
    begin
      //то он является локальным экстремумом если он не равен предпоследнему элементу
      isCurElementIsLocalExtremum :=
        curElement <> StrToFloat(StringList.Strings[StringList.Count - 2]);
    end
    //иначе
    else
    begin
      //сохраняем предыдущий элемент в отдельную переменную
      prevElement := StrToFloat(StringList.Strings[i - 1]);

      //сохраняем следующий элемент в отдельную переменную
      nextElement := StrToFloat(StringList.Strings[i + 1]);

      //если текущий элемент равен предыдущему или следующему
      if (prevElement = curElement) or (nextElement = curElement) then
      begin
        //то он точно не является локальным экстремумом
        isCurElementIsLocalExtremum := false;
      end
      else
      begin
        //иначе элемент является локальным экстремум если он больше или меньше чем оба его соседа
        isCurElementIsLocalExtremum :=
          (prevElement - curElement) / Abs(prevElement - curElement) =
          (nextElement - curElement) / Abs(nextElement - curElement);
      end;
    end;
    //если элемент не является локальным экстремумом
    //и больше последнего найденного элемента не являющегося локальным экстремумом
    if (not isCurElementIsLocalExtremum) and
      (StrToFloat(StringList.Strings[i]) > maxWantedElement) then
    begin
      //помечаем, что существуют элементы, которые не являются локальными экстремумами
      isAtLeastOneWantedElementExist := true;
      //сохраняем его значение
      maxWantedElement := curElement;
    end;
  end;

  //если существует хотя бы один элемент не являющийся локальным экстремумом
  if isAtLeastOneWantedElementExist then
  begin
    //то выводим его
    ResultLabel.Caption := FloatToStr(maxWantedElement);
  end
  else
  begin
    //иначе выводим 0
    ResultLabel.Caption := '0';
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //Инициализируем поле ввода
  ArrayEdit.Text := '-2 -3,4 -22 22,4 7';
end;

end.
