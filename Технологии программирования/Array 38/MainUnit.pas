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
  curDecreasingSequenceLength: integer; //длина текущий убывающей последовательности
  decreasingSequenceCount: integer;     //кол-во убывающих последовательностей
  curElement, prevElement: real;        //текущий и предыдущий элемент соответственно
begin
  //изначально найдено 0 убывающих последовательностей
  decreasingSequenceCount := 0;
  //начальная длина первой "последовательности" равна 1
  curDecreasingSequenceLength := 1;

  //создаем объект, с помощью которого будем из введенной строки делать массив
  StringList := TStringList.Create;

  //указываем разделяющий символ
  StringList.Delimiter := ' ';
  //указываем строку, которую нужно поделить
  StringList.DelimitedText := ArrayEdit.Text;

  //берем индекс каждого элемента, кроме 0
  for i := 1 to StringList.Count - 1 do
  begin
    //сохраняем в отдельную переменную текущий элемент
    curElement := StrToFloat(StringList[i]);
    //сохраняем в отдельную переменную предыдущий элемент
    prevElement := StrToFloat(StringList[i - 1]);
    //если элемент не нарушает монотонно убывающую последовательность
    if curElement <= prevElement then
    begin
      //то увеличиваем длину последовательности
      curDecreasingSequenceLength := curDecreasingSequenceLength + 1;
    end;

    //если текущая последовательность закончилась
    if (curElement > prevElement) or (i = StringList.Count - 1) then
    begin
      //если длина текущей последовательности больше 1
      if curDecreasingSequenceLength > 1 then
      begin
        //то ее действительно считаем ее последовательностью
        //и увеличиваем кол-во найденных последовательностей
        decreasingSequenceCount := decreasingSequenceCount + 1;
      end;
      //длина следующей "последовательности" изначально будет равна 0
      curDecreasingSequenceLength := 1;
    end;
  end;
  //выводим кол-во найденных последовательностей
  ResultLabel.Caption := FloatToStr(decreasingSequenceCount);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //Инициализируем поле ввода
  ArrayEdit.Text := '-2 -3,5 -4 3,5 3,2 3,2 1,7';
end;

end.
