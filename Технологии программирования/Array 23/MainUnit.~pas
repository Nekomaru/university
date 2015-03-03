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
    KLabel: TLabel;
    KEdit: TEdit;
    LEdit: TEdit;
    LLabel: TLabel;
    AverageLabel: TLabel;
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
  Sum: Real;       //сумма, среднее арифметическое
  StringList: TStringList;  //объект для преобразования строки в массив
  i: integer;               //итератор
  K, L: Real;
  ElementCount: integer;    //кол-во элементов СА которых нужно посчитать
begin
  //создаем объект, с помощью которого будем из введенной строки делать массив
  StringList := TStringList.Create;

  //указываем разделяющий символ
  StringList.Delimiter := ' ';
  //указываем строку, которую нужно поделить
  StringList.DelimitedText := ArrayEdit.Text;

  //изначально сумма элементов равно нулю
  Sum := 0;
  //а кол-во элементов, среднее арифметическое которых нужно посчитать, равно
  //длине введенного массива
  ElementCount := StringList.Count;

  //считываем K
  K := StrToInt(KEdit.Text);
  //считываем L
  L := StrToInt(LEdit.Text);

  //берем индекс каждего элемента массива
  for i := 0 to StringList.Count - 1 do
  begin
    //проверяем находится ли он за пределами интервала [K, L]
    if (i < K) or (i > L) then
    begin
      //если находится то к общей сумме прибавляем текущий элемент
      Sum := Sum + StrToFloat(StringList.Strings[i]);
    end
    else
    begin
      //иначе уменьшаем кол-во элеметнов, среднее арифметическое которых нужно посчитать
      ElementCount := ElementCount - 1;
    end;
  end;
  //делим сумму элементов на их кол-во и выводим получившиеся значение
  AverageLabel.Caption := 'Среднее арифметическое: ' + FloatToStr(Sum / ElementCount);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //Инициализируем поля ввода
  ArrayEdit.Text := '1 2 3 4 5 6';
  KEdit.Text := '2';
  LEdit.Text := '3';
end;

end.
