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
  StringList: TStringList;      //объект дл€ преобразовани€ строки в массив
  i: integer;                   //итератор
  pairWithMaxSumIndex: integer; //индекс пары с максимальной суммой
  maxPairSum: real;             //максимальн€ сумма пары
  pairFirstElement: real;       //первый элемент пары
  pairSecondElement: real;      //второй элемент пары
begin
  //изначально максимальна€ сумма пары равна минимальн овозможному числу
  maxPairSum := -Infinity;

  //создаем объект, с помощью которого будем из введенной строки делать массив
  StringList := TStringList.Create;

  //указываем раздел€ющий символ
  StringList.Delimiter := ' ';
  //указываем строку, которую нужно поделить
  StringList.DelimitedText := ArrayEdit.Text;

  //берем индекс каждого элемента, кроме последнего
  for i := 0 to StringList.Count - 2 do
  begin
    //сохран€ем в отдельную переменную первый элемент пары
    pairFirstElement := StrToFloat(StringList.Strings[i]);
    //сохран€ем в отдельную переменную второй элемент пары
    pairSecondElement := StrToFloat(StringList.Strings[i + 1]);
    //если сумма текущей пары больше чем текуща€ максимальна€ сумма пары
    if pairFirstElement + pairSecondElement > maxPairSum then
    begin
      //то сохран€ем сумму текущей пары как максимальную
      maxPairSum := pairFirstElement + pairSecondElement;
      //и также сохран€ем индекс текущей пары
      pairWithMaxSumIndex := i;
    end;
  end;
  //выводим элементы образующие пару с максимальной суммой
  ResultLabel.Caption := StringList.Strings[pairWithMaxSumIndex] + ' ' +
    StringList.Strings[pairWithMaxSumIndex + 1]; 
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //»нициализируем поле ввода
  ArrayEdit.Text := '-7,3 8,4 12,1 14,5 2,1';
end;

end.
